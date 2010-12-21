From: Madhu Iyengar <madhu.iyengar@qlogic.com>
Subject: RE: [PATCH 07/12] qla2xxx: Convert to host_lock less w/ interrupts
	disabled externally
Date: Mon, 20 Dec 2010 16:37:58 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87225A0F1BC@AVEXMB1.qlogic.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
	 <1292793727-31957-8-git-send-email-nab@linux-iscsi.org>
	 <20101219231114.GI1263@parisc-linux.org>
 <1292837033.20840.39.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_003_5E4F49720D0BAD499EE1F01232234BA87225A0F1BCAVEXMB1qlogic_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:28083 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab0LUAiC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2010 19:38:02 -0500
In-Reply-To: <1292837033.20840.39.camel@haakon2.linux-iscsi.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff Garzik <jeff@garzik.org>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>

--_003_5E4F49720D0BAD499EE1F01232234BA87225A0F1BCAVEXMB1qlogic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

All,

We had (internally @ QLogic) come up with a couple of patches (attached).

Patch 1: Similar to the patch from NAB and from Mathew Wilcox
Patch 2: A bit more changes with the host_lost within the qla2xxx driver.

The above 2 patches have gone through some testing as well, so far so good.=
 Please take a look and let us know.

Cheers,
Madhu

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of Nicholas A. Bellinger
Sent: Monday, December 20, 2010 1:24 AM
To: Matthew Wilcox
Cc: linux-scsi; linux-kernel; James Bottomley; Jeff Garzik; Christoph Hellw=
ig; FUJITA Tomonori; Hannes Reinecke; Mike Christie; Mike Anderson; Tejun H=
eo; Vasu Dev; Tim Chen; Andi Kleen; Ravi Anand; Andrew Vasquez; Joe Eykholt=
; James Smart; Douglas Gilbert; adam radford; Kashyap Desai; MPTFusionLinux
Subject: Re: [PATCH 07/12] qla2xxx: Convert to host_lock less w/ interrupts=
 disabled externally

On Sun, 2010-12-19 at 16:11 -0700, Matthew Wilcox wrote:
> On Sun, Dec 19, 2010 at 01:22:02PM -0800, Nicholas A. Bellinger wrote:
> > This patch converts qla2xxx to run in host_lock less mode with the new
> > IRQ_DISABLE_SCSI_QCMD() that disables interrupts while calling ->queuec=
ommand()
> > dispatch.  It also drops the legacy host_lock unlock optimization.
>=20
> I'm not sure this is the right direction to go.  Now that Jeff's done
> the pushdown and put in the compatibility macros, I don't think it makes
> sense to do another partial transition on each driver.  Much better to
> take our time, analyse each driver thoroughly, and kill the DEF_SCSI_QCMD
> in each driver without introducing IRQ_DISABLE_SCSI_QCMD.
>=20
> In particular for this driver, it explicitly re-enables interrupts,
> so it's pretty easy to do a full conversion.  Compile-tested only.
>=20
> Convert qla2xxx driver to run without the shost lock
>=20
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Ok, this patch is functioning with LTP disktest I/O using .37-rc6
initiator side lock_less operation.

This has been added as an incremental patch for lock_less-LLDs-for-38-v3
here:

commit 355798dc3d97a0f07b14d1f3891ecca1802c9094
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Mon Dec 20 01:24:12 2010 -0800

    qla2xxx: Convert qla2xxx driver to run without the shost lock
   =20
    This patch converts qla2xxx LLD code to run in fully lock-less mode
    and removes IRQ_DISABLE_SCSI_QCMD usage.  This also includes a handful
    of cleanups for cmd->scsi_done assignment removal from qla2x00_get_new_=
sp()
    and renames one goto of the exception patch with the '_lock' suffix in
    qla2xxx_queuecommand().
   =20
    So far this patch has been lightly tested with basic I/O functionality =
on
    bare-metal x86_64 .37-rc6 using ISP-2532 8 Gb/sec HW.
   =20
    Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
    Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Thanks!

--nab

>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 2c0876c..b44d986 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -513,7 +513,7 @@ qla24xx_fw_version_str(struct scsi_qla_host *vha, cha=
r *str)
> =20
>  static inline srb_t *
>  qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
> -    struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> +    struct scsi_cmnd *cmd)
>  {
>  	srb_t *sp;
>  	struct qla_hw_data *ha =3D vha->hw;
> @@ -527,16 +527,15 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t =
*fcport,
>  	sp->cmd =3D cmd;
>  	sp->flags =3D 0;
>  	CMD_SP(cmd) =3D (void *)sp;
> -	cmd->scsi_done =3D done;
>  	sp->ctx =3D NULL;
> =20
>  	return sp;
>  }
> =20
>  static int
> -qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi=
_cmnd *))
> +qla2xxx_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>  {
> -	scsi_qla_host_t *vha =3D shost_priv(cmd->device->host);
> +	scsi_qla_host_t *vha =3D shost_priv(shost);
>  	fc_port_t *fcport =3D (struct fc_port *) cmd->device->hostdata;
>  	struct fc_rport *rport =3D starget_to_rport(scsi_target(cmd->device));
>  	struct qla_hw_data *ha =3D vha->hw;
> @@ -544,7 +543,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void =
(*done)(struct scsi_cmnd *)
>  	srb_t *sp;
>  	int rval;
> =20
> -	spin_unlock_irq(vha->host->host_lock);
>  	if (ha->flags.eeh_busy) {
>  		if (ha->flags.pci_channel_io_perm_failure)
>  			cmd->result =3D DID_NO_CONNECT << 16;
> @@ -577,39 +575,32 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, voi=
d (*done)(struct scsi_cmnd *)
>  		goto qc24_target_busy;
>  	}
> =20
> -	sp =3D qla2x00_get_new_sp(base_vha, fcport, cmd, done);
> +	sp =3D qla2x00_get_new_sp(base_vha, fcport, cmd);
>  	if (!sp)
> -		goto qc24_host_busy_lock;
> +		goto qc24_host_busy;
> =20
>  	rval =3D ha->isp_ops->start_scsi(sp);
>  	if (rval !=3D QLA_SUCCESS)
>  		goto qc24_host_busy_free_sp;
> =20
> -	spin_lock_irq(vha->host->host_lock);
> -
>  	return 0;
> =20
>  qc24_host_busy_free_sp:
>  	qla2x00_sp_free_dma(sp);
>  	mempool_free(sp, ha->srb_mempool);
> =20
> -qc24_host_busy_lock:
> -	spin_lock_irq(vha->host->host_lock);
> +qc24_host_busy:
>  	return SCSI_MLQUEUE_HOST_BUSY;
> =20
>  qc24_target_busy:
> -	spin_lock_irq(vha->host->host_lock);
>  	return SCSI_MLQUEUE_TARGET_BUSY;
> =20
>  qc24_fail_command:
> -	spin_lock_irq(vha->host->host_lock);
> -	done(cmd);
> +	cmd->scsi_done(cmd);
> =20
>  	return 0;
>  }
> =20
> -static DEF_SCSI_QCMD(qla2xxx_queuecommand)
> -
> =20
>  /*
>   * qla2x00_eh_wait_on_command
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--_003_5E4F49720D0BAD499EE1F01232234BA87225A0F1BCAVEXMB1qlogic_
Content-Type: application/octet-stream;
	name="qla2xxx-Remove-host_lock-in-queuecommand-function.patch"
Content-Description: qla2xxx-Remove-host_lock-in-queuecommand-function.patch
Content-Disposition: attachment;
	filename="qla2xxx-Remove-host_lock-in-queuecommand-function.patch";
	size=2854; creation-date="Mon, 20 Dec 2010 15:27:56 GMT";
	modification-date="Mon, 20 Dec 2010 15:27:56 GMT"
Content-Transfer-Encoding: base64

RnJvbTogTWFkaHVyYW5hdGggSXllbmdhciA8TWFkaHUuSXllbmdhckBxbG9naWMuY29tPg0KRGF0
ZTogTW9uLCAyMCBEZWMgMjAxMCAyMjo0Mjo0MCArMDAwMCAoLTA4MDApDQpTdWJqZWN0OiBxbGEy
eHh4OiBSZW1vdmUgaG9zdF9sb2NrIGluIHF1ZXVlY29tbWFuZCBmdW5jdGlvbg0KWC1HaXQtVXJs
OiBodHRwOi8vZ2l0bG54L2dpdD9wPW1peWVuZ2FyJTJGcWxhMnh4eC11cHN0cmVhbS5naXQ7YT1j
b21taXRkaWZmX3BsYWluO2g9NTU5MDEzODQ5MjczYzAyMDBjNDcyYjEzYzFmN2U3OTgwMjdlODNi
NQ0KDQpxbGEyeHh4OiBSZW1vdmUgaG9zdF9sb2NrIGluIHF1ZXVlY29tbWFuZCBmdW5jdGlvbg0K
DQpBbHNvIGluIHFsYV9vcy5jLCByZW5hbWUgdGhlIGZ1bmN0aW9uLCByZW1vdmUgREVGX1NDU0lf
UUNNRCwgZXRjLg0KDQpTaWduZWQtb2ZmLWJ5OiBNYWRodXJhbmF0aCBJeWVuZ2FyIDxNYWRodS5J
eWVuZ2FyQHFsb2dpYy5jb20+DQotLS0NCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9vcy5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMNCmluZGV4IDJjMDg3
NmMuLmU2YmQ0YWUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYw0K
KysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX29zLmMNCkBAIC01MTMsNyArNTEzLDcgQEAg
cWxhMjR4eF9md192ZXJzaW9uX3N0cihzdHJ1Y3Qgc2NzaV9xbGFfaG9zdCAqdmhhLCBjaGFyICpz
dHIpDQogDQogc3RhdGljIGlubGluZSBzcmJfdCAqDQogcWxhMngwMF9nZXRfbmV3X3NwKHNjc2lf
cWxhX2hvc3RfdCAqdmhhLCBmY19wb3J0X3QgKmZjcG9ydCwNCi0gICAgc3RydWN0IHNjc2lfY21u
ZCAqY21kLCB2b2lkICgqZG9uZSkoc3RydWN0IHNjc2lfY21uZCAqKSkNCisgICAgc3RydWN0IHNj
c2lfY21uZCAqY21kKQ0KIHsNCiAJc3JiX3QgKnNwOw0KIAlzdHJ1Y3QgcWxhX2h3X2RhdGEgKmhh
ID0gdmhhLT5odzsNCkBAIC01MjcsMTQgKzUyNywxMyBAQCBxbGEyeDAwX2dldF9uZXdfc3Aoc2Nz
aV9xbGFfaG9zdF90ICp2aGEsIGZjX3BvcnRfdCAqZmNwb3J0LA0KIAlzcC0+Y21kID0gY21kOw0K
IAlzcC0+ZmxhZ3MgPSAwOw0KIAlDTURfU1AoY21kKSA9ICh2b2lkICopc3A7DQotCWNtZC0+c2Nz
aV9kb25lID0gZG9uZTsNCiAJc3AtPmN0eCA9IE5VTEw7DQogDQogCXJldHVybiBzcDsNCiB9DQog
DQogc3RhdGljIGludA0KLXFsYTJ4eHhfcXVldWVjb21tYW5kX2xjayhzdHJ1Y3Qgc2NzaV9jbW5k
ICpjbWQsIHZvaWQgKCpkb25lKShzdHJ1Y3Qgc2NzaV9jbW5kICopKQ0KK3FsYTJ4eHhfcXVldWVj
b21tYW5kKHN0cnVjdCBTY3NpX0hvc3QgKmhvc3QsIHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCiB7
DQogCXNjc2lfcWxhX2hvc3RfdCAqdmhhID0gc2hvc3RfcHJpdihjbWQtPmRldmljZS0+aG9zdCk7
DQogCWZjX3BvcnRfdCAqZmNwb3J0ID0gKHN0cnVjdCBmY19wb3J0ICopIGNtZC0+ZGV2aWNlLT5o
b3N0ZGF0YTsNCkBAIC01NDQsNyArNTQzLDYgQEAgcWxhMnh4eF9xdWV1ZWNvbW1hbmRfbGNrKHN0
cnVjdCBzY3NpX2NtbmQgKmNtZCwgdm9pZCAoKmRvbmUpKHN0cnVjdCBzY3NpX2NtbmQgKikNCiAJ
c3JiX3QgKnNwOw0KIAlpbnQgcnZhbDsNCiANCi0Jc3Bpbl91bmxvY2tfaXJxKHZoYS0+aG9zdC0+
aG9zdF9sb2NrKTsNCiAJaWYgKGhhLT5mbGFncy5lZWhfYnVzeSkgew0KIAkJaWYgKGhhLT5mbGFn
cy5wY2lfY2hhbm5lbF9pb19wZXJtX2ZhaWx1cmUpDQogCQkJY21kLT5yZXN1bHQgPSBESURfTk9f
Q09OTkVDVCA8PCAxNjsNCkBAIC01NzcsNDAgKzU3NSwzMiBAQCBxbGEyeHh4X3F1ZXVlY29tbWFu
ZF9sY2soc3RydWN0IHNjc2lfY21uZCAqY21kLCB2b2lkICgqZG9uZSkoc3RydWN0IHNjc2lfY21u
ZCAqKQ0KIAkJZ290byBxYzI0X3RhcmdldF9idXN5Ow0KIAl9DQogDQotCXNwID0gcWxhMngwMF9n
ZXRfbmV3X3NwKGJhc2VfdmhhLCBmY3BvcnQsIGNtZCwgZG9uZSk7DQorCXNwID0gcWxhMngwMF9n
ZXRfbmV3X3NwKGJhc2VfdmhhLCBmY3BvcnQsIGNtZCk7DQogCWlmICghc3ApDQotCQlnb3RvIHFj
MjRfaG9zdF9idXN5X2xvY2s7DQorCQlnb3RvIHFjMjRfaG9zdF9idXN5Ow0KIA0KIAlydmFsID0g
aGEtPmlzcF9vcHMtPnN0YXJ0X3Njc2koc3ApOw0KIAlpZiAocnZhbCAhPSBRTEFfU1VDQ0VTUykN
CiAJCWdvdG8gcWMyNF9ob3N0X2J1c3lfZnJlZV9zcDsNCiANCi0Jc3Bpbl9sb2NrX2lycSh2aGEt
Pmhvc3QtPmhvc3RfbG9jayk7DQotDQogCXJldHVybiAwOw0KIA0KIHFjMjRfaG9zdF9idXN5X2Zy
ZWVfc3A6DQogCXFsYTJ4MDBfc3BfZnJlZV9kbWEoc3ApOw0KIAltZW1wb29sX2ZyZWUoc3AsIGhh
LT5zcmJfbWVtcG9vbCk7DQogDQotcWMyNF9ob3N0X2J1c3lfbG9jazoNCi0Jc3Bpbl9sb2NrX2ly
cSh2aGEtPmhvc3QtPmhvc3RfbG9jayk7DQorcWMyNF9ob3N0X2J1c3k6DQogCXJldHVybiBTQ1NJ
X01MUVVFVUVfSE9TVF9CVVNZOw0KIA0KIHFjMjRfdGFyZ2V0X2J1c3k6DQotCXNwaW5fbG9ja19p
cnEodmhhLT5ob3N0LT5ob3N0X2xvY2spOw0KIAlyZXR1cm4gU0NTSV9NTFFVRVVFX1RBUkdFVF9C
VVNZOw0KIA0KIHFjMjRfZmFpbF9jb21tYW5kOg0KLQlzcGluX2xvY2tfaXJxKHZoYS0+aG9zdC0+
aG9zdF9sb2NrKTsNCi0JZG9uZShjbWQpOw0KKwljbWQtPnNjc2lfZG9uZShjbWQpOw0KIA0KIAly
ZXR1cm4gMDsNCiB9DQogDQotc3RhdGljIERFRl9TQ1NJX1FDTUQocWxhMnh4eF9xdWV1ZWNvbW1h
bmQpDQotDQotDQogLyoNCiAgKiBxbGEyeDAwX2VoX3dhaXRfb25fY29tbWFuZA0KICAqICAgIFdh
aXRzIGZvciB0aGUgY29tbWFuZCB0byBiZSByZXR1cm5lZCBieSB0aGUgRmlybXdhcmUgZm9yIHNv
bWUNCg==

--_003_5E4F49720D0BAD499EE1F01232234BA87225A0F1BCAVEXMB1qlogic_
Content-Type: text/plain;
	name="qla2xxx-Change-from-irq-to-irqsave-with-host_lock.txt"
Content-Description: qla2xxx-Change-from-irq-to-irqsave-with-host_lock.txt
Content-Disposition: attachment;
	filename="qla2xxx-Change-from-irq-to-irqsave-with-host_lock.txt"; size=3741;
	creation-date="Mon, 20 Dec 2010 15:29:37 GMT";
	modification-date="Mon, 20 Dec 2010 15:29:37 GMT"
Content-Transfer-Encoding: base64

RnJvbTogTWFkaHVyYW5hdGggSXllbmdhciA8TWFkaHUuSXllbmdhckBxbG9naWMuY29tPg0KRGF0
ZTogVHVlLCA3IERlYyAyMDEwIDIzOjM0OjU5ICswMDAwICgtMDgwMCkNClN1YmplY3Q6IHFsYTJ4
eHg6IENoYW5nZSBmcm9tIGlycSB0byBpcnFzYXZlIHdpdGggaG9zdF9sb2NrDQpYLUdpdC1Vcmw6
IGh0dHA6Ly9naXRsbngvZ2l0P3A9bWl5ZW5nYXIlMkZxbGEyeHh4LXVwc3RyZWFtLmdpdDthPWNv
bW1pdGRpZmZfcGxhaW47aD1jZmRmYmI1MmVmMjk5YWJjYjcwMmZjNzM5NWYzMjE1NTZmZDFjYWIw
DQoNCnFsYTJ4eHg6IENoYW5nZSBmcm9tIGlycSB0byBpcnFzYXZlIHdpdGggaG9zdF9sb2NrDQoN
Ck1ha2UgdGhlIGRyaXZlciBzYWZlciBieSB1c2luZyBpcnFzYXZlL2lycXJlc3RvcmUgd2l0aCBo
b3N0X2xvY2suDQoNClNpZ25lZC1vZmYtYnk6IE1hZGh1cmFuYXRoIEl5ZW5nYXIgPE1hZGh1Lkl5
ZW5nYXJAcWxvZ2ljLmNvbT4NCi0tLQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4
eHgvcWxhX2F0dHIuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9hdHRyLmMNCmluZGV4IGJj
ODE5NGYuLjMwZjkyMzEgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfYXR0
ci5jDQorKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfYXR0ci5jDQpAQCAtMTUzNCw2ICsx
NTM0LDcgQEAgcWxhMngwMF9kZXZfbG9zc190bW9fY2FsbGJrKHN0cnVjdCBmY19ycG9ydCAqcnBv
cnQpDQogew0KIAlzdHJ1Y3QgU2NzaV9Ib3N0ICpob3N0ID0gcnBvcnRfdG9fc2hvc3QocnBvcnQp
Ow0KIAlmY19wb3J0X3QgKmZjcG9ydCA9ICooZmNfcG9ydF90ICoqKXJwb3J0LT5kZF9kYXRhOw0K
Kwl1bnNpZ25lZCBsb25nIGZsYWdzOw0KIA0KIAlpZiAoIWZjcG9ydCkNCiAJCXJldHVybjsNCkBA
IC0xNTQ2LDEwICsxNTQ3LDEwIEBAIHFsYTJ4MDBfZGV2X2xvc3NfdG1vX2NhbGxiayhzdHJ1Y3Qg
ZmNfcnBvcnQgKnJwb3J0KQ0KIAkgKiBUcmFuc3BvcnQgaGFzIGVmZmVjdGl2ZWx5ICdkZWxldGVk
JyB0aGUgcnBvcnQsIGNsZWFyDQogCSAqIGFsbCBsb2NhbCByZWZlcmVuY2VzLg0KIAkgKi8NCi0J
c3Bpbl9sb2NrX2lycShob3N0LT5ob3N0X2xvY2spOw0KKwlzcGluX2xvY2tfaXJxc2F2ZShob3N0
LT5ob3N0X2xvY2ssIGZsYWdzKTsNCiAJZmNwb3J0LT5ycG9ydCA9IGZjcG9ydC0+ZHJwb3J0ID0g
TlVMTDsNCiAJKigoZmNfcG9ydF90ICoqKXJwb3J0LT5kZF9kYXRhKSA9IE5VTEw7DQotCXNwaW5f
dW5sb2NrX2lycShob3N0LT5ob3N0X2xvY2spOw0KKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKGhv
c3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KIA0KIAlpZiAodGVzdF9iaXQoQUJPUlRfSVNQX0FDVElW
RSwgJmZjcG9ydC0+dmhhLT5kcGNfZmxhZ3MpKQ0KIAkJcmV0dXJuOw0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFf
aW5pdC5jDQppbmRleCAyNTlmNTExLi5kZmVkNTA0IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3Np
L3FsYTJ4eHgvcWxhX2luaXQuYw0KKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQu
Yw0KQEAgLTI1MDMsMTEgKzI1MDMsMTIgQEAgcWxhMngwMF9ycG9ydF9kZWwodm9pZCAqZGF0YSkN
CiB7DQogCWZjX3BvcnRfdCAqZmNwb3J0ID0gZGF0YTsNCiAJc3RydWN0IGZjX3Jwb3J0ICpycG9y
dDsNCisJdW5zaWduZWQgbG9uZyBmbGFnczsNCiANCi0Jc3Bpbl9sb2NrX2lycShmY3BvcnQtPnZo
YS0+aG9zdC0+aG9zdF9sb2NrKTsNCisJc3Bpbl9sb2NrX2lycXNhdmUoZmNwb3J0LT52aGEtPmhv
c3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KIAlycG9ydCA9IGZjcG9ydC0+ZHJwb3J0ID8gZmNwb3J0
LT5kcnBvcnQ6IGZjcG9ydC0+cnBvcnQ7DQogCWZjcG9ydC0+ZHJwb3J0ID0gTlVMTDsNCi0Jc3Bp
bl91bmxvY2tfaXJxKGZjcG9ydC0+dmhhLT5ob3N0LT5ob3N0X2xvY2spOw0KKwlzcGluX3VubG9j
a19pcnFyZXN0b3JlKGZjcG9ydC0+dmhhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCiAJaWYg
KHJwb3J0KQ0KIAkJZmNfcmVtb3RlX3BvcnRfZGVsZXRlKHJwb3J0KTsNCiB9DQpAQCAtMjg3Nyw2
ICsyODc4LDcgQEAgcWxhMngwMF9yZWdfcmVtb3RlX3BvcnQoc2NzaV9xbGFfaG9zdF90ICp2aGEs
IGZjX3BvcnRfdCAqZmNwb3J0KQ0KIAlzdHJ1Y3QgZmNfcnBvcnRfaWRlbnRpZmllcnMgcnBvcnRf
aWRzOw0KIAlzdHJ1Y3QgZmNfcnBvcnQgKnJwb3J0Ow0KIAlzdHJ1Y3QgcWxhX2h3X2RhdGEgKmhh
ID0gdmhhLT5odzsNCisJdW5zaWduZWQgbG9uZyBmbGFnczsNCiANCiAJcWxhMngwMF9ycG9ydF9k
ZWwoZmNwb3J0KTsNCiANCkBAIC0yODkxLDkgKzI4OTMsOSBAQCBxbGEyeDAwX3JlZ19yZW1vdGVf
cG9ydChzY3NpX3FsYV9ob3N0X3QgKnZoYSwgZmNfcG9ydF90ICpmY3BvcnQpDQogCQkgICAgIlVu
YWJsZSB0byBhbGxvY2F0ZSBmYyByZW1vdGUgcG9ydCFcbiIpOw0KIAkJcmV0dXJuOw0KIAl9DQot
CXNwaW5fbG9ja19pcnEoZmNwb3J0LT52aGEtPmhvc3QtPmhvc3RfbG9jayk7DQorCXNwaW5fbG9j
a19pcnFzYXZlKGZjcG9ydC0+dmhhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCiAJKigoZmNf
cG9ydF90ICoqKXJwb3J0LT5kZF9kYXRhKSA9IGZjcG9ydDsNCi0Jc3Bpbl91bmxvY2tfaXJxKGZj
cG9ydC0+dmhhLT5ob3N0LT5ob3N0X2xvY2spOw0KKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKGZj
cG9ydC0+dmhhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCiANCiAJcnBvcnQtPnN1cHBvcnRl
ZF9jbGFzc2VzID0gZmNwb3J0LT5zdXBwb3J0ZWRfY2xhc3NlczsNCiANCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfb3MuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9v
cy5jDQppbmRleCBlNmJkNGFlLi4zYjQ0MWM4IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zY3NpL3Fs
YTJ4eHgvcWxhX29zLmMNCisrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9vcy5jDQpAQCAt
MjUxMCw2ICsyNTEwLDcgQEAgcWxhMngwMF9zY2hlZHVsZV9ycG9ydF9kZWwoc3RydWN0IHNjc2lf
cWxhX2hvc3QgKnZoYSwgZmNfcG9ydF90ICpmY3BvcnQsDQogew0KIAlzdHJ1Y3QgZmNfcnBvcnQg
KnJwb3J0Ow0KIAlzY3NpX3FsYV9ob3N0X3QgKmJhc2VfdmhhOw0KKwl1bnNpZ25lZCBsb25nIGZs
YWdzOw0KIA0KIAlpZiAoIWZjcG9ydC0+cnBvcnQpDQogCQlyZXR1cm47DQpAQCAtMjUxNyw5ICsy
NTE4LDkgQEAgcWxhMngwMF9zY2hlZHVsZV9ycG9ydF9kZWwoc3RydWN0IHNjc2lfcWxhX2hvc3Qg
KnZoYSwgZmNfcG9ydF90ICpmY3BvcnQsDQogCXJwb3J0ID0gZmNwb3J0LT5ycG9ydDsNCiAJaWYg
KGRlZmVyKSB7DQogCQliYXNlX3ZoYSA9IHBjaV9nZXRfZHJ2ZGF0YSh2aGEtPmh3LT5wZGV2KTsN
Ci0JCXNwaW5fbG9ja19pcnEodmhhLT5ob3N0LT5ob3N0X2xvY2spOw0KKwkJc3Bpbl9sb2NrX2ly
cXNhdmUodmhhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCiAJCWZjcG9ydC0+ZHJwb3J0ID0g
cnBvcnQ7DQotCQlzcGluX3VubG9ja19pcnEodmhhLT5ob3N0LT5ob3N0X2xvY2spOw0KKwkJc3Bp
bl91bmxvY2tfaXJxcmVzdG9yZSh2aGEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KIAkJc2V0
X2JpdChGQ1BPUlRfVVBEQVRFX05FRURFRCwgJmJhc2VfdmhhLT5kcGNfZmxhZ3MpOw0KIAkJcWxh
Mnh4eF93YWtlX2RwYyhiYXNlX3ZoYSk7DQogCX0gZWxzZQ0K

--_003_5E4F49720D0BAD499EE1F01232234BA87225A0F1BCAVEXMB1qlogic_--
