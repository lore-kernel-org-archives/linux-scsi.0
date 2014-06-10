From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH v1 3/3] TARGET/sbc,loopback: Adjust command data length
 in case pi exists on the wire
Date: Tue, 10 Jun 2014 21:17:19 +0000
Message-ID: <504EB66DAC8D234EB8E8560985C2D7AD46D1D00E@avmb2.qlogic.org>
References: <1402223228-23768-1-git-send-email-sagig@mellanox.com>
 <1402223228-23768-4-git-send-email-sagig@mellanox.com>
 <1402387450.5774.56.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_504EB66DAC8D234EB8E8560985C2D7AD46D1D00Eavmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:27025 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbaFJVRW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2014 17:17:22 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id s5ALEuNB021622
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 14:17:21 -0700
Received: from avcashub1.qlogic.com (avcashub3.qlogic.com [198.70.193.117])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1madc17upm-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 14:17:20 -0700
In-Reply-To: <1402387450.5774.56.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "roland@kernel.org" <roland@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>

--_000_504EB66DAC8D234EB8E8560985C2D7AD46D1D00Eavmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0662EE50D205DE4E82908CC214FAECA7@qlogic.com>
Content-Transfer-Encoding: quoted-printable

All,

Comments inline.

Regards,
Quinn Tran




On 6/10/14 1:04 AM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>Hi Sagi & Co,
>
>On Sun, 2014-06-08 at 13:27 +0300, Sagi Grimberg wrote:
>> In various areas of the code, it is assumed that
>> se_cmd->data_length describes pure data. In case
>> that protection information exists over the wire
>> (protect bits is are on) the target core decrease
>> the protection length from the data length (instead
>> of each transport peeking in the cdb).
>>
>> Modify loopback device to include protection information
>> in the transferred data length (like other scsi transports).
>>
>> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
>> ---
>>  drivers/target/loopback/tcm_loop.c |   15 ++++++++++++---
>>  drivers/target/target_core_sbc.c   |   15 +++++++++++++--
>>  2 files changed, 25 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/target/loopback/tcm_loop.c
>>b/drivers/target/loopback/tcm_loop.c
>> index c886ad1..1f4c015 100644
>> --- a/drivers/target/loopback/tcm_loop.c
>> +++ b/drivers/target/loopback/tcm_loop.c
>> @@ -179,7 +179,7 @@ static void tcm_loop_submission_work(struct
>>work_struct *work)
>>      struct tcm_loop_hba *tl_hba;
>>      struct tcm_loop_tpg *tl_tpg;
>>      struct scatterlist *sgl_bidi =3D NULL;
>> -    u32 sgl_bidi_count =3D 0;
>> +    u32 sgl_bidi_count =3D 0, transfer_length;
>>      int rc;
>>
>>      tl_hba =3D *(struct tcm_loop_hba **)shost_priv(sc->device->host);
>> @@ -213,12 +213,21 @@ static void tcm_loop_submission_work(struct
>>work_struct *work)
>>
>>      }
>>
>> -    if (!scsi_prot_sg_count(sc) && scsi_get_prot_op(sc) !=3D
>>SCSI_PROT_NORMAL)
>> +    transfer_length =3D scsi_transfer_length(sc);
>> +    if (!scsi_prot_sg_count(sc) &&
>> +        scsi_get_prot_op(sc) !=3D SCSI_PROT_NORMAL) {
>>              se_cmd->prot_pto =3D true;
>> +            /*
>> +             * loopback transport doesn't support
>> +             * WRITE_GENERATE, READ_STRIP protection
>> +             * information operations, go ahead unprotected.
>> +             */
>> +            transfer_length =3D scsi_bufflen(sc);
>> +    }
>>
>>      rc =3D target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cm=
nd,
>>                      &tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
>> -                    scsi_bufflen(sc), tcm_loop_sam_attr(sc),
>> +                    transfer_length, tcm_loop_sam_attr(sc),
>>                      sc->sc_data_direction, 0,
>>                      scsi_sglist(sc), scsi_sg_count(sc),
>>                      sgl_bidi, sgl_bidi_count,
>> diff --git a/drivers/target/target_core_sbc.c
>>b/drivers/target/target_core_sbc.c
>> index e022959..06f8ecd 100644
>> --- a/drivers/target/target_core_sbc.c
>> +++ b/drivers/target/target_core_sbc.c
>> @@ -665,8 +665,19 @@ sbc_check_prot(struct se_device *dev, struct
>>se_cmd *cmd, unsigned char *cdb,
>>
>>      cmd->prot_type =3D dev->dev_attrib.pi_prot_type;
>>      cmd->prot_length =3D dev->prot_length * sectors;
>> -    pr_debug("%s: prot_type=3D%d, prot_length=3D%d prot_op=3D%d
>>prot_checks=3D%d\n",
>> -             __func__, cmd->prot_type, cmd->prot_length,
>> +
>> +    /**
>> +     * In case protection information exists over the wire
>> +     * we modify command data length to describe pure data.
>> +     * The actual transfer length is data length + protection
>> +     * length
>> +     **/
>> +    if (protect)
>> +            cmd->data_length -=3D cmd->prot_length;
>> +

QT> Instead of using existing value within cmd->data_length, can we
calculated data_length based on secstors & blocksize.

cmd->data_length =3D sectors * dev->dev_attrib.block_size;


>From the QLogic perfective, the cmd->data_length is pull directly from the
wire (i.e. FCP header) when cmd is received.  In essence, it's whatever
the Initiator is set it to.  We does not have any indicator to spot DIF vs
none-DIF cmd when 1st received, unless the code do a peek.

With that said, the cmd->data_length does not guarantee to contain both
"data length" & "protection length" when cmd is submit to
TCM/target_submit_cmd().  In Dif-Insert mode, data_length will only
contain the actual data(no Dif).

It's best that the SBC code re-calculate the actual data length and dif
data length based on the number of sectors derived from the cmd.

Thanks.

>
>This fabric wide assumption breaks the vhost-scsi + tcm_qla2xxx PI code
>already queued for v3.16-rc1..
>
>A vhost-scsi side conversion to combine exp_data_len + prot_bytes is
>easy enough in target-pending/for-next (see below), given that
>vhost-scsi's exp_data_len is coming from virtio buffer iovecs, so
>changing virtio-scsi LLD to use scsi_transfer_length() doesn't really
>make any sense. (Adding CC's for MST + Paolo)
>
>The qla2xxx target T10 PI patch in scsi/for-next (adding Quinn CC) will
>also need a similar change to update qlt_do_work() to include PI bytes
>for data_length being passed into tgt_ops->handle_cmd(), following what
>qlt_build_ctio_crc2_pkt() is already doing for calculating
>transfer_length for HW offload.
>
>That said, there is one other small qla2xxx change to enable per-session
>PI that is currently missing in Quinn's patch in scsi/for-next code.

QT> I've been bog down with other front, I have not had a chance to come
back and re-patch this area. Will find some cycle to work on this soon.

>
>Sooo, I'll go ahead and include Sagi's patches with the vhost-scsi
>change below if there are no objections from MKP and/or driver
>maintainers, and post an -rc2 series after the merge window closes to
>address the two remaining qla2xxx specific items.
>
>--nab
>
>diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
>index 667e72d..03e484f 100644
>--- a/drivers/vhost/scsi.c
>+++ b/drivers/vhost/scsi.c
>@@ -1144,7 +1144,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct
>vhost_virtqueue *vq)
>                }
>
>                cmd =3D vhost_scsi_get_tag(vq, tpg, cdb, tag, lun,
>task_attr,
>-                                        exp_data_len, data_direction);
>+                                        exp_data_len + prot_bytes,
>+                                        data_direction);
>                if (IS_ERR(cmd)) {
>                        vq_err(vq, "vhost_scsi_get_tag failed %ld\n",
>                                        PTR_ERR(cmd));
>


________________________________

This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--_000_504EB66DAC8D234EB8E8560985C2D7AD46D1D00Eavmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+It8yAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAADg5QkVCNkY4
MkNGOTFBNDE5Nzk4RTQ1QTlCMUU5QzRDAG0HAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HBgAKABUA
EQATAAIAMAEBIIADAA4AAADeBwYACgAVABEAEwACADABAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAGEAAABSZTogW1BBVENIIHYxIDMvM10gVEFSR0VUL3NiYyxsb29wYmFj
azogQWRqdXN0IGNvbW1hbmQgZGF0YSBsZW5ndGggaW4gY2FzZSBwaSBleGlzdHMgb24gdGhlIHdp
cmUAOyABA5AGABAcAAA1AAAAAgF/AAEAAAA8AAAAPDUwNEVCNjZEQUM4RDIzNEVCOEU4NTYwOTg1
QzJEN0FENDZEMUQwMEVAYXZtYjIucWxvZ2ljLm9yZz4ACwAfDgEAAAACAQkQAQAAANwOAADYDgAA
gB8AAExaRnX10n2gYQAKZmJpZAQAAGNjwHBnMTI1MgD+A0PwdGV4dAH3AqQD4wIABGNoCsBzZXQw
IO8HbQKDAFARTTIKgAa0AoCWfQqACMg7CWIxOQ7AvwnDFnIKMhZxAoAVYioJsHMJ8ASQYXQFsg5Q
A2Bzom8BgCBFeBHBbhgwXQZSdgSQF7YCEHIAwHR9CFBuGjEQIAXABaAbZGSaIANSIBAiF7JcdgiQ
5HdrC4BkNR1TBPAHQA0XcDAKcRfyYmttawZzAZAAICBCTV9C4EVHSU59CvwB8QvxgCBBbGwsXGwL
gO5lCoEh9AhQbQeAAjAEIIsLgCHyLiHsUmVnCxGycyHWUXULgAOgVBhwLwuQIfsmryISTwOgNi+D
HpAooDQgMTowKPBAQU0sICJODlBopQbwYQQgQS4fsGUhsIMLgBgwciIgPG4BoKJAIfF1eC0EAGMA
kMIuBbBnPiB3A2AQIKI6Iew+SGkGAWct4GwmIAhQIdY+LVYoYVMcdW4pgAHQKOAtMDYZMGA4IBiA
KQAzOjLgNyArMDMeoCmALgOuRwUQBtAEkGcsfD4sYOpJA6B2CsBpCGAEIArA7mUqERkwHMBoGeAF
oAEAvSmAaQVABAAwwAQQdQeAHxxgNPAYgDMYEgBfY22QZC0+ZBiAYV8ecHsZwDTwIAEABPIyYAQg
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
AHUAaQBuAG4AIABUAHIAYQBuAAAAAAAfAB8MAQAAACwAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAA
cQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAAAAIBGQwBAAAAZAAA
AAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFEAdQBpAG4AbgAgAFQAcgBhAG4AAABTAE0AVABQAAAA
cQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAFdAQAAACwAAABx
AHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A+D8BAAAAFgAAAFEA
dQBpAG4AbgAgAFQAcgBhAG4AAAAAAB8AI0ABAAAALAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABx
AGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAABkAAAA
AAAAAIErH6S+oxAZnW4A3QEPVAIAAACAUQB1AGkAbgBuACAAVAByAGEAbgAAAFMATQBUAFAAAABx
AHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8ACV0BAAAALAAAAHEA
dQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAxQAEAAAACAAAAAAAA
AAsAQDoBAAAAHwAwQAEAAAACAAAAAAAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAA
AwDxPwkEAAALAEA6AQAAAAMA/T/kBAAAAgELMAEAAAAQAAAAib62+Cz5GkGXmORamx6cTAMAFwAB
AAAAQAA5AIAZclzxhM8BQAAIMGeVfVzxhM8BCwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAFIUAAAEA
AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBl
AAAAAAABAAAADAAAAGUAbgAtAFUAUwAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAA
HwA3AAEAAADCAAAAUgBlADoAIABbAFAAQQBUAEMASAAgAHYAMQAgADMALwAzAF0AIABUAEEAUgBH
AEUAVAAvAHMAYgBjACwAbABvAG8AcABiAGEAYwBrADoAIABBAGQAagB1AHMAdAAgAGMAbwBtAG0A
YQBuAGQAIABkAGEAdABhACAAbABlAG4AZwB0AGgAIABpAG4AIABjAGEAcwBlACAAcABpACAAZQB4
AGkAcwB0AHMAIABvAG4AIAB0AGgAZQAgAHcAaQByAGUAAAAAAB8APQABAAAACgAAAFIAZQA6ACAA
AAAAAAMANgAAAAAAHwBCEAEAAAByAAAAPAAxADQAMAAyADMAOAA3ADQANQAwAC4ANQA3ADcANAAu
ADUANgAuAGMAYQBtAGUAbABAAGgAYQBhAGsAbwBuADMALgByAGkAcwBpAG4AZwB0AGkAZABlAHMA
eQBzAHQAZQBtAHMALgBjAG8AbQA+AAAAAAACAXEAAQAAACAAAAABAc+DBEVazFKUIdN2RoBWDesW
6eN7m2p0bgCAAGg/gB8AcAABAAAAugAAAFsAUABBAFQAQwBIACAAdgAxACAAMwAvADMAXQAgAFQA
QQBSAEcARQBUAC8AcwBiAGMALABsAG8AbwBwAGIAYQBjAGsAOgAgAEEAZABqAHUAcwB0ACAAYwBv
AG0AbQBhAG4AZAAgAGQAYQB0AGEAIABsAGUAbgBnAHQAaAAgAGkAbgAgAGMAYQBzAGUAIABwAGkA
IABlAHgAaQBzAHQAcwAgAG8AbgAgAHQAaABlACAAdwBpAHIAZQAAAAAAHwA1EAEAAAB4AAAAPAA1
ADAANABFAEIANgA2AEQAQQBDADgARAAyADMANABFAEIAOABFADgANQA2ADAAOQA4ADUAQwAyAEQA
NwBBAEQANAA2AEQAMQBEADAAMABFAEAAYQB2AG0AYgAyAC4AcQBsAG8AZwBpAGMALgBvAHIAZwA+
AAAAHwA5EAEAAABOAQAAPAAxADQAMAAyADIAMgAzADIAMgA4AC0AMgAzADcANgA4AC0AMQAtAGcA
aQB0AC0AcwBlAG4AZAAtAGUAbQBhAGkAbAAtAHMAYQBnAGkAZwBAAG0AZQBsAGwAYQBuAG8AeAAu
AGMAbwBtAD4AIAA8ADEANAAwADIAMgAyADMAMgAyADgALQAyADMANwA2ADgALQA0AC0AZwBpAHQA
LQBzAGUAbgBkAC0AZQBtAGEAaQBsAC0AcwBhAGcAaQBnAEAAbQBlAGwAbABhAG4AbwB4AC4AYwBv
AG0APgAgADwAMQA0ADAAMgAzADgANwA0ADUAMAAuADUANwA3ADQALgA1ADYALgBjAGEAbQBlAGwA
QABoAGEAYQBrAG8AbgAzAC4AcgBpAHMAaQBuAGcAdABpAGQAZQBzAHkAcwB0AGUAbQBzAC4AYwBv
AG0APgAAAAAAAwDeP59OAABAAAcwR3F2XPGEzwEDACYAAAAAAAIBRwABAAAALQAAAGM9VVM7YT0g
O3A9UUxvZ2ljO2w9QVZNQjItMTQwNjEwMjExNzE5Wi03NTgyAAAAAB8AFRABAAAAWAAAADAANgA2
ADIARQBFADUAMABEADIAMAA1AEQARQA0AEUAOAAyADkAMAA4AEMAQwAyADEANABGAEEARQBDAEEA
NwBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAACARQwAQAAAAwAAABfAgAA33e6JUEAAAAfAPo/AQAA
ABYAAABRAHUAaQBuAG4AIABUAHIAYQBuAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAWAAAA
dQBzAGUAcgAtAGEAZwBlAG4AdAAAAAAAAQAAAEYAAABNAGkAYwByAG8AcwBvAGYAdAAtAE0AYQBj
AE8AdQB0AGwAbwBvAGsALwAxADQALgA0AC4AMgAuADEANAAwADUAMAA5AAAAAAAfAACAH6TrM6h6
LkK+e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBlAHIAcwBhAHQAaQBvAG4ASQBuAGQAZQB4AFQAcgBh
AGMAawBpAG4AZwBFAHgAAAABAAAAQgEAAEkASQA9ADAAMQAwADEAQwBGADgANABGADEANQBDADIA
OABEAEEANwA5ADUAMAA3AEUAQQA0ADAANgA0ADMAQgBCADkAQQBBADAAOQBBADQAQQA1ADYANwA2
AEIANQA7AFMAQgBNAEkARAA9ADMAOwBTADEAPQA8ADEANAAwADIAMwA4ADcANAA1ADAALgA1ADcA
NwA0AC4ANQA2AC4AYwBhAG0AZQBsAEAAaABhAGEAawBvAG4AMwAuAHIAaQBzAGkAbgBnAHQAaQBk
AGUAcwB5AHMAdABlAG0AcwAuAGMAbwBtAD4AOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8A
bgAgADEANAAuADIAIAAoAEIAdQBpAGwAZAAgADMAOAA3AC4AMAApACwAIABTAHQAYQBnAGUAPQBI
ADIAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEA
cwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAA
AHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAAAAEAAAAaAAAAWwAxADAALgAzAC4A
MQAwAC4AOAAxAF0AAAAAAMZI

--_000_504EB66DAC8D234EB8E8560985C2D7AD46D1D00Eavmb2qlogicorg_--
