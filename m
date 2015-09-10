From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [PATCH] target/qla2xxx: Honor max_data_sg_nents I/O transfer
 limit
Date: Thu, 10 Sep 2015 22:16:08 +0000
Message-ID: <D2174D86.B2810%himanshu.madhani@qlogic.com>
References: <1439455550-2626-1-git-send-email-nab@daterainc.com>
 <alpine.LRH.2.00.1508171724150.19116@mvluser04.mv.qlogic.com>
 <1440112633.14304.23.camel@haakon3.risingtidesystems.com>
 <1441842255.6836.13.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_D2174D86B2810himanshumadhaniqlogiccom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:23322 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbbIJWQN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Sep 2015 18:16:13 -0400
Received: from pps.filterd (m0085408.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t8AMGCts005943
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2015 15:16:12 -0700
Received: from avcashub1.qlogic.com (avcashub2.qlogic.com [198.70.193.116])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1wqycnfx70-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2015 15:16:12 -0700
In-Reply-To: <1441842255.6836.13.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Arun Easi <arun.easi@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Craig Watson <craig.watson@vanguard-rugged.com>, Roland Dreier <roland@purestorage.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

--_000_D2174D86B2810himanshumadhaniqlogiccom_
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <F4E3ED3E7CF28E41B01538E295BA572B@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Hi Nic,=20

Sorry about the delay in response.

I have tested with RHEL 6.5 and noticed that IO were not able to complete
with 16M and 32M read/write. IO=B9s were getting error due to Mid-layer
underflow

With initiator running upstream kernel version 4.2 as well I was seeing
error with Mid-layer reporting under-run.

I made change in the driver to report DID_OK to Mid-layer with residual
count and I was able to see IO completed without any error.
Basically, overriding driver=B9s logic of failing an I/O, when residual
makes it an error with scsi_cmnd->underflow set.
In reality, though, with scsi_cmnd->underflow being set, Linux Qlogic
initiator will always see this as an error.
Maybe this is useful in other OSes. We have verified both read and write
data on FC trace and it looks good.

Here=B9s diff that was done in qla2xxx driver to report response to
mid-layer as DID_OK.


# git diff
diff --git a/drivers/scsi/qla2xxx/qla_isr.c
b/drivers/scsi/qla2xxx/qla_isr.c
index ccf6a7f..fc7b6a2 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2257,7 +2257,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct
rsp_que *rsp, void *pkt)
                                    "detected (0x%x of 0x%x bytes).\n",
                                    resid, scsi_bufflen(cp));

-                               res =3D DID_ERROR << 16;
+                               res =3D DID_OK << 16;
                                break;
                        }
                } else if (lscsi_status !=3D SAM_STAT_TASK_SET_FULL &&
(END)


Please go ahead and add patch to mainline kernel.

Thanks,
-Himanshu




On 9/9/15, 4:44 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>Hi Arun & Co,
>
>On Thu, 2015-08-20 at 16:17 -0700, Nicholas A. Bellinger wrote:
>> On Wed, 2015-08-19 at 17:48 -0700, Arun Easi wrote:
>> > Hi nab,
>> >=20
>> > On Thu, 13 Aug 2015, 1:45am -0700, Nicholas A. Bellinger wrote:
>> >=20
>> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
>> > >
>> > > Hi Arun, Roland & Co,
>> > >
>> > > Based upon the feedback from last week, here is a proper
>> > > patch for target-core to honor a fabric provided SGL limit
>> > > using residual count plus underflow response bit.
>> > >
>> > > Everything appears to be working as expected with tcm-loop
>> > > LUNs with basic I/O and sg_raw to test CDB underflow, but
>> > > still needs to be verified on real qla2xxx hardware over
>> > > the next days for v4.2.0 code.
>> > >
>> > > Please review + test.
>> >=20
>> > Changes look good. I could not test the changes, though. I have
>>requested=20
>> > internally to test this patch. Himanshu (copied) will get back with
>>the=20
>> > test results (Thanks Himanshu).
>> >=20
>>=20
>> Thanks for the update.  Btw, this patch has been pushed to
>> refs/heads/queue, atop the other recent v4.2-rc fixes here:
>>=20
>>=20
>>https://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commi
>>t/?h=3Dqueue
>>=20
>> Just an FYI for Himanshu, for testing against Linux hosts that do honor
>> EVPD block-limits, you'll want to include the following small hack to
>> report a larger block-limits value so the new residual handling can
>> actually get invoked.
>>=20
>> diff --git a/drivers/target/target_core_spc.c
>>b/drivers/target/target_core_spc.c
>> index 01421e9..f02767b 100644
>> --- a/drivers/target/target_core_spc.c
>> +++ b/drivers/target/target_core_spc.c
>> @@ -523,6 +523,7 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned
>>char *buf)
>>         if (cmd->se_tfo->max_data_sg_nents) {
>>                 mtl =3D (cmd->se_tfo->max_data_sg_nents * PAGE_SIZE) /
>>                        dev->dev_attrib.block_size;
>> +               mtl *=3D 2;
>>         }
>>         put_unaligned_be32(min_not_zero(mtl,
>>dev->dev_attrib.hw_max_sectors), &buf[8]);
>>=20
>> Also for testing, I'd recommend lowering tcm_qla2xxx's max_data_sg_nents
>> to something arbitrarily small to exercise the new code.
>>=20
>> Craig, have you had a chance to test the new logic on your setup with
>> hosts that don't honor EVPD block-limits..?
>>=20
>
>I've not seen any testing feedback on this patch over the last weeks
>from Himanshu or Craig.
>
>So barring any specific objections, I think it's safe enough to include
>in the upcoming v4.3-rc1 PULL request, minus the stable CC'.
>
>Himanshu + Craig, please let me know how your testing is going.
>
>Based upon your feedback we can address any regressions post merge, and
>subsequently get the patch (plus any other bugfixes) picked up for
>stable code.
>
>Thank you,
>
>--nab


--_000_D2174D86B2810himanshumadhaniqlogiccom_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
XQEAAAA4AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4A
YwBvAG0AAAAfAOVfAQAAAEAAAABzAGkAcAA6AGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBu
AGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAaDAEAAAAiAAAASABpAG0AYQBuAHMAaAB1ACAA
TQBhAGQAaABhAG4AaQAAAAAAHwAfDAEAAAA4AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABh
AG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAB4MAQAAAAoAAABTAE0AVABQAAAAAAACARkM
AQAAAHwAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBIAGkAbQBhAG4AcwBoAHUAIABNAGEAZABo
AGEAbgBpAAAAUwBNAFQAUAAAAGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwA
bwBnAGkAYwAuAGMAbwBtAAAAHwABXQEAAAA4AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABh
AG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAPg/AQAAACIAAABIAGkAbQBhAG4AcwBoAHUA
IABNAGEAZABoAGEAbgBpAAAAAAAfACNAAQAAADgAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABo
AGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AIkABAAAACgAAAFMATQBUAFAAAAAAAAIB
+T8BAAAAfAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEgAaQBtAGEAbgBzAGgAdQAgAE0AYQBk
AGgAYQBuAGkAAABTAE0AVABQAAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEA
bABvAGcAaQBjAC4AYwBvAG0AAAAfAAldAQAAADgAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABo
AGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAsAQDoBAAAAHwAaAAEAAAASAAAASQBQAE0A
LgBOAG8AdABlAAAAAAADAPE/CQQAAAsAQDoBAAAAAwD9P+QEAAACAQswAQAAABAAAAB/DeZZly9O
S74aECRjlC6FAwAXAAEAAABAADkAAISsShbs0AFAAAgwpfUoSxbs0AELAACACCAGAAAAAADAAAAA
AAAARgAAAAAUhQAAAQAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAAdABs
AGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAMAAAAZQBuAC0AVQBTAAAACwAAgAggBgAAAAAAwAAAAAAA
AEYAAAAABoUAAAAAAAAfADcAAQAAAI4AAABSAGUAOgAgAFsAUABBAFQAQwBIAF0AIAB0AGEAcgBn
AGUAdAAvAHEAbABhADIAeAB4AHgAOgAgAEgAbwBuAG8AcgAgAG0AYQB4AF8AZABhAHQAYQBfAHMA
ZwBfAG4AZQBuAHQAcwAgAEkALwBPACAAdAByAGEAbgBzAGYAZQByACAAbABpAG0AaQB0AAAAAAAf
AD0AAQAAAAoAAABSAGUAOgAgAAAAAAADADYAAAAAAB8AQhABAAAAcgAAADwAMQA0ADQAMQA4ADQA
MgAyADUANQAuADYAOAAzADYALgAxADMALgBjAGEAbQBlAGwAQABoAGEAYQBrAG8AbgAzAC4AcgBp
AHMAaQBuAGcAdABpAGQAZQBzAHkAcwB0AGUAbQBzAC4AYwBvAG0APgAAAAAAAgFxAAEAAAAqAAAA
AQHQ1aVNB1MHDA92l0aRnTUAsppqvJ4UjfQAgAF4y4CAH3YugIABBFeAAAAfAHAAAQAAAIYAAABb
AFAAQQBUAEMASABdACAAdABhAHIAZwBlAHQALwBxAGwAYQAyAHgAeAB4ADoAIABIAG8AbgBvAHIA
IABtAGEAeABfAGQAYQB0AGEAXwBzAGcAXwBuAGUAbgB0AHMAIABJAC8ATwAgAHQAcgBhAG4AcwBm
AGUAcgAgAGwAaQBtAGkAdAAAAAAAHwA1EAEAAABaAAAAPABEADIAMQA3ADQARAA4ADYALgBCADIA
OAAxADAAJQBoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBj
AG8AbQA+AAAAAAAfADkQAQAAAMwBAAA8ADEANAAzADkANAA1ADUANQA1ADAALQAyADYAMgA2AC0A
MQAtAGcAaQB0AC0AcwBlAG4AZAAtAGUAbQBhAGkAbAAtAG4AYQBiAEAAZABhAHQAZQByAGEAaQBu
AGMALgBjAG8AbQA+ACAAPABhAGwAcABpAG4AZQAuAEwAUgBIAC4AMgAuADAAMAAuADEANQAwADgA
MQA3ADEANwAyADQAMQA1ADAALgAxADkAMQAxADYAQABtAHYAbAB1AHMAZQByADAANAAuAG0AdgAu
AHEAbABvAGcAaQBjAC4AYwBvAG0APgAgADwAMQA0ADQAMAAxADEAMgA2ADMAMwAuADEANAAzADAA
NAAuADIAMwAuAGMAYQBtAGUAbABAAGgAYQBhAGsAbwBuADMALgByAGkAcwBpAG4AZwB0AGkAZABl
AHMAeQBzAHQAZQBtAHMALgBjAG8AbQA+ACAAPAAxADQANAAxADgANAAyADIANQA1AC4ANgA4ADMA
NgAuADEAMwAuAGMAYQBtAGUAbABAAGgAYQBhAGsAbwBuADMALgByAGkAcwBpAG4AZwB0AGkAZABl
AHMAeQBzAHQAZQBtAHMALgBjAG8AbQA+AAAAAwDeP69vAABAAAcwKXAfSxbs0AEDACYAAAAAAAIB
RwABAAAALgAAAGM9VVM7YT0gO3A9UUxvZ2ljO2w9QVZNQjMtMTUwOTEwMjIxNjA4Wi03MDI4NgAA
AB8AFRABAAAAWAAAAEYANABFADMARQBEADMARQA3AEMARgAyADgARQA0ADEAQgAwADEANQAzADgA
RQAyADkANQBCAEEANQA3ADIAQgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAACARQwAQAAAAwAAAAf
AgAAk5PVTkgAAAAfAPo/AQAAACIAAABIAGkAbQBhAG4AcwBoAHUAIABNAGEAZABoAGEAbgBpAAAA
AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAWAAAAdQBzAGUAcgAtAGEAZwBlAG4AdAAAAAAAAQAA
AEYAAABNAGkAYwByAG8AcwBvAGYAdAAtAE0AYQBjAE8AdQB0AGwAbwBvAGsALwAxADQALgAzAC4A
OQAuADEAMwAxADAAMwAwAAAAAAAfAACAH6TrM6h6LkK+e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBl
AHIAcwBhAHQAaQBvAG4ASQBuAGQAZQB4AFQAcgBhAGMAawBpAG4AZwBFAHgAAAABAAAAQgEAAEkA
SQA9ADAAMQAwADEARAAwAEUAQwAxADYANABCAEYAQwA3AEEAQgBCADUANgBBADgAOABGADkAMgA0
ADIAOAA3AEYANQBCAEUAOQBCADQARQBDADkAMwBCADAANQA7AFMAQgBNAEkARAA9ADMAOwBTADEA
PQA8ADEANAA0ADEAOAA0ADIAMgA1ADUALgA2ADgAMwA2AC4AMQAzAC4AYwBhAG0AZQBsAEAAaABh
AGEAawBvAG4AMwAuAHIAaQBzAGkAbgBnAHQAaQBkAGUAcwB5AHMAdABlAG0AcwAuAGMAbwBtAD4A
OwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8AbgAgADEANAAuADMAIAAoAEIAdQBpAGwAZAAg
ADIAMwA1AC4AMAApACwAIABTAHQAYQBnAGUAPQBIADIAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAA
wAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAA
AAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcA
LQBpAHAAAAAAAAEAAAAYAAAAWwAxADAALgAxAC4ANAAuADEAMABdAAAAHwAAgIYDAgAAAAAAwAAA
AAAAAEYBAAAAFgAAAGQAaQBzAGMAbABhAGkAbQBlAHIAAAAAAAEAAAAOAAAAYgB5AHAAYQBzAHMA
AAAAAELn

--_000_D2174D86B2810himanshumadhaniqlogiccom_--
