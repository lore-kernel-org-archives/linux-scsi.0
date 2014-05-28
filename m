From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH 39/42] qla2xxx: ABTS cause double free of qla_tgt_cmd +.
Date: Wed, 28 May 2014 18:52:47 +0000
Message-ID: <504EB66DAC8D234EB8E8560985C2D7AD46D09012@avmb2.qlogic.org>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
 <1397249687-32666-40-git-send-email-saurav.kashyap@qlogic.com>
 <1400814012.9595.37.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_504EB66DAC8D234EB8E8560985C2D7AD46D09012avmb2qlogicorg_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:53677 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932065AbaE1Swu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2014 14:52:50 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id s4SIqkTk030474
	for <linux-scsi@vger.kernel.org>; Wed, 28 May 2014 11:52:49 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1kurt27nps-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 28 May 2014 11:52:49 -0700
In-Reply-To: <1400814012.9595.37.camel@haakon3.risingtidesystems.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

--_000_504EB66DAC8D234EB8E8560985C2D7AD46D09012avmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <684684C44AB1954EB374E5A51996B4CC@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Nicholas,

At this point we can forgo this patch to stable tree.  There are
additional tweaks in this path during testing.  We will update the stable
tree with new findings.

Thanks.

Regards,
Quinn Tran



On 5/22/14 8:00 PM, "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

>Hi Saurav + Quinn,
>
>Just curious if this fix needs to be CC'ed to stable as well, or if it's
>something that is only triggered with the preceding T10 DIF support
>patch in place..?
>
>--nab
>
>On Fri, 2014-04-11 at 16:54 -0400, Saurav Kashyap wrote:
>> From: Quinn Tran <quinn.tran@qlogic.com>
>>
>> Fix double free problem within qla2xxx driver where
>> current code prematurely free qla_tgt_cmd while firmware
>> still has the command.  When firmware release the command
>> after abort, the code attempt a second free as part of
>> command completion processing.
>>
>> When TCM start the free process, NULL pointer was hit.
>>
>> ------
>> WARNING: CPU: 8 PID: 43613 at lib/list_debug.c:62
>>__list_del_entry+0x82/0xd0()
>> list_del corruption. next->prev should be ffff88082b5cfb08, but was
>>6b6b6b6b6b6b6b6b
>> CPU: 8 PID: 43613 Comm: kworker/8:0 Tainted: GF       W  O
>>3.13.0-rc3-nab_t10dif+ #6
>> Hardware name: HP ProLiant DL380p Gen8, BIOS P70 08/20/2012
>> Workqueue: events cache_reap
>> 000000000000003e ffff88081b2e3c78 ffffffff815a051f 000000000000003e
>> ffff88081b2e3cc8 ffff88081b2e3cb8 ffffffff8104fc2c 0000000000000000
>> ffff88082b5cfb00 ffff88081c788d00 ffff88082b5d7200 ffff88082b5d3080
>> Call Trace:
>> [<ffffffff815a051f>] dump_stack+0x49/0x62
>> [<ffffffff8104fc2c>] warn_slowpath_common+0x8c/0xc0
>> [<ffffffff8104fd16>] warn_slowpath_fmt+0x46/0x50
>> [<ffffffff812b6592>] __list_del_entry+0x82/0xd0
>> [<ffffffff8106d48c>] process_one_work+0x12c/0x510
>> [<ffffffff8106d4d3>] ? process_one_work+0x173/0x510
>> [<ffffffff8106ebdf>] worker_thread+0x11f/0x3a0
>> [<ffffffff8106eac0>] ? manage_workers+0x170/0x170
>> [<ffffffff81074f26>] kthread+0xf6/0x120
>> [<ffffffff8109f103>] ? __lock_release+0x133/0x1b0
>> [<ffffffff81074e30>] ? __init_kthread_worker+0x70/0x70
>> [<ffffffff815aec2c>] ret_from_fork+0x7c/0xb0
>> [<ffffffff81074e30>] ? __init_kthread_worker+0x70/0x70
>> ---[ end trace dfc05c3f7caf8ebe ]---
>> BUG: unable to handle kernel NULL pointer dereference at
>>0000000000000008
>> IP: [<ffffffff8106d391>] process_one_work+0x31/0x510
>> -------
>>
>> Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
>> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
>> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
>> ---
>>  drivers/scsi/qla2xxx/qla_target.c |   29 ++++++++++++++++++++++++++---
>>  1 files changed, 26 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_target.c
>>b/drivers/scsi/qla2xxx/qla_target.c
>> index f24d44c..b1d10f9 100644
>> --- a/drivers/scsi/qla2xxx/qla_target.c
>> +++ b/drivers/scsi/qla2xxx/qla_target.c
>> @@ -2681,7 +2681,18 @@ static void qlt_send_term_exchange(struct
>>scsi_qla_host *vha,
>>      rc =3D __qlt_send_term_exchange(vha, cmd, atio);
>>      spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
>>  done:
>> -    if (rc =3D=3D 1) {
>> +    /*
>> +     * Terminate exchange will tell fw to release any active CTIO
>> +     * that's in FW posession and cleanup the exchange.
>> +     *
>> +     * "cmd->state =3D=3D QLA_TGT_STATE_ABORTED" means CTIO is still
>> +     * down at FW.  Free the cmd later when CTIO comes back later
>> +     * w/aborted(0x2) status.
>> +     *
>> +     * "cmd->state !=3D QLA_TGT_STATE_ABORTED" means CTIO is already
>> +     * back w/some err.  Free the cmd now.
>> +     */
>> +    if ((rc =3D=3D 1) && (cmd->state !=3D QLA_TGT_STATE_ABORTED)) {
>>              if (!ha_locked && !in_interrupt())
>>                      msleep(250); /* just in case */
>>
>> @@ -2689,6 +2700,7 @@ done:
>>                      qlt_unmap_sg(vha, cmd);
>>              vha->hw->tgt.tgt_ops->free_cmd(cmd);
>>      }
>> +    return;
>>  }
>>
>>  void qlt_free_cmd(struct qla_tgt_cmd *cmd)
>> @@ -2906,6 +2918,7 @@ static void qlt_do_ctio_completion(struct
>>scsi_qla_host *vha, uint32_t handle,
>>              case CTIO_LIP_RESET:
>>              case CTIO_TARGET_RESET:
>>              case CTIO_ABORTED:
>> +                    /* driver request abort via Terminate exchange */
>>              case CTIO_TIMEOUT:
>>              case CTIO_INVALID_RX_ID:
>>                      /* They are OK */
>> @@ -2974,9 +2987,18 @@ static void qlt_do_ctio_completion(struct
>>scsi_qla_host *vha, uint32_t handle,
>>                      break;
>>              }
>>
>> -            if (cmd->state !=3D QLA_TGT_STATE_NEED_DATA)
>> +
>> +            /* "cmd->state =3D=3D QLA_TGT_STATE_ABORTED" means
>> +             * cmd is already aborted/terminated, we don't
>> +             * need to terminate again.  The exchange is already
>> +             * cleaned up/freed at FW level.  Just cleanup at driver
>> +             * level.
>> +             */
>> +            if ((cmd->state !=3D QLA_TGT_STATE_NEED_DATA) &&
>> +                    (cmd->state !=3D QLA_TGT_STATE_ABORTED)) {
>>                      if (qlt_term_ctio_exchange(vha, ctio, cmd, status))
>>                              return;
>> +            }
>>      }
>>  skip_term:
>>
>> @@ -3007,7 +3029,8 @@ skip_term:
>>                  "not return a CTIO complete\n", vha->vp_idx, cmd->state=
);
>>      }
>>
>> -    if (unlikely(status !=3D CTIO_SUCCESS)) {
>> +    if (unlikely(status !=3D CTIO_SUCCESS) &&
>> +            (cmd->state !=3D QLA_TGT_STATE_ABORTED)) {
>>              ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01f, "Finishing failed CTIO\=
n");
>>              dump_stack();
>>      }
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


________________________________

This message and any attached documents contain information from QLogic Cor=
poration or its wholly-owned subsidiaries that may be confidential. If you =
are not the intended recipient, you may not read, copy, distribute, or use =
this information. If you have received this transmission in error, please n=
otify the sender immediately by reply e-mail and then delete this message.

--_000_504EB66DAC8D234EB8E8560985C2D7AD46D09012avmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
thZNAAHCCOuxZglgFkGBZ2B0dHA6Ly/CvaovwhctxRIuxaBtFMb/yEz7UMmvyovITF+QFFHBZn8N
ggoDxbAZABgAF3AV8GP7t5C9gHThoQ1Q3cAMgcUS/1bA/YIYILxzrwDaIhgwAAB/DODYQM/jAADr
sM7BF/Bv/QjwedeAFhAtIbvS9lBWcP/xsOGRDBLCAQogvEHO8eFgL+OQZwBWcIGxSQRAeW/+dV/T
oKIOQi3C69EXcBbQ/mOeYNOAZwDiMNWS1BKgpPd+MP0ROyB54jDlgGSxvDD+da6g4jDRsRvgFvIU
Uc9579VHDCAKgdchZQpxvaIUUf9kwCDBB4ANJAyBI9EAAOIw/2QxMgKgoeWQCiAOQvuyVVH8aW0g
oNNBCNHUMQogFtDzZDAKIGUtN5AIkA1zDkE/GCDU0KICvLTBZYVGfX0DtmDkgAAAAB8AQgABAAAA
FgAAAFEAdQBpAG4AbgAgAFQAcgBhAG4AAAAAAB8AZQABAAAALAAAAHEAdQBpAG4AbgAuAHQAcgBh
AG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwBkAAEAAAAKAAAAUwBNAFQAUAAAAAAAAgFBAAEA
AABkAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAUQB1AGkAbgBuACAAVAByAGEAbgAAAFMATQBU
AFAAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AAl0BAAAA
LAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwDlXwEAAAA0
AAAAcwBpAHAAOgBxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A
GgwBAAAAFgAAAFEAdQBpAG4AbgAgAFQAcgBhAG4AAAAAAB8AHwwBAAAALAAAAHEAdQBpAG4AbgAu
AHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAA
AgEZDAEAAABkAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACAUQB1AGkAbgBuACAAVAByAGEAbgAA
AFMATQBUAFAAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A
AV0BAAAALAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwD4
PwEAAAAWAAAAUQB1AGkAbgBuACAAVAByAGEAbgAAAAAAHwAjQAEAAAAsAAAAcQB1AGkAbgBuAC4A
dAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfACJAAQAAAAoAAABTAE0AVABQAAAAAAAC
Afk/AQAAAGQAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBRAHUAaQBuAG4AIABUAHIAYQBuAAAA
UwBNAFQAUAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAJ
XQEAAAAsAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfADFA
AQAAAAIAAAAAAAAACwBAOgEAAAAfADBAAQAAAAIAAAAAAAAAHwAaAAEAAAASAAAASQBQAE0ALgBO
AG8AdABlAAAAAAADAPE/CQQAAAsAQDoBAAAAAwD9P+QEAAACAQswAQAAABAAAAB5YMUEL3eUSbUe
rAljDHNVAwAXAAEAAABAADkAgCkpBKZ6zwFAAAgwek5/BKZ6zwELAACACCAGAAAAAADAAAAAAAAA
RgAAAAAUhQAAAQAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAAdABsAGEA
bgBnAHUAYQBnAGUAAAAAAAEAAAAMAAAAZQBuAC0AVQBTAAAACwAAgAggBgAAAAAAwAAAAAAAAEYA
AAAABoUAAAAAAAAfADcAAQAAAIgAAABSAGUAOgAgAFsAUABBAFQAQwBIACAAMwA5AC8ANAAyAF0A
IABxAGwAYQAyAHgAeAB4ADoAIABBAEIAVABTACAAYwBhAHUAcwBlACAAZABvAHUAYgBsAGUAIABm
AHIAZQBlACAAbwBmACAAcQBsAGEAXwB0AGcAdABfAGMAbQBkACAAKwAuAAAAHwA9AAEAAAAKAAAA
UgBlADoAIAAAAAAAAwA2AAAAAAAfAEIQAQAAAHIAAAA8ADEANAAwADAAOAAxADQAMAAxADIALgA5
ADUAOQA1AC4AMwA3AC4AYwBhAG0AZQBsAEAAaABhAGEAawBvAG4AMwAuAHIAaQBzAGkAbgBnAHQA
aQBkAGUAcwB5AHMAdABlAG0AcwAuAGMAbwBtAD4AAAAAAAIBcQABAAAAGwAAAAEBz3YzKqVdn5mS
GOxCrPV3m5vu2YqbVl+hgAAfAHAAAQAAAIAAAABbAFAAQQBUAEMASAAgADMAOQAvADQAMgBdACAA
cQBsAGEAMgB4AHgAeAA6ACAAQQBCAFQAUwAgAGMAYQB1AHMAZQAgAGQAbwB1AGIAbABlACAAZgBy
AGUAZQAgAG8AZgAgAHEAbABhAF8AdABnAHQAXwBjAG0AZAAgACsALgAAAB8ANRABAAAAeAAAADwA
NQAwADQARQBCADYANgBEAEEAQwA4AEQAMgAzADQARQBCADgARQA4ADUANgAwADkAOAA1AEMAMgBE
ADcAQQBEADQANgBEADAAOQAwADEAMgBAAGEAdgBtAGIAMgAuAHEAbABvAGcAaQBjAC4AbwByAGcA
PgAAAB8AORABAAAAbAEAADwAMQAzADkANwAyADQAOQA2ADgANwAtADMAMgA2ADYANgAtADEALQBn
AGkAdAAtAHMAZQBuAGQALQBlAG0AYQBpAGwALQBzAGEAdQByAGEAdgAuAGsAYQBzAGgAeQBhAHAA
QABxAGwAbwBnAGkAYwAuAGMAbwBtAD4AIAA8ADEAMwA5ADcAMgA0ADkANgA4ADcALQAzADIANgA2
ADYALQA0ADAALQBnAGkAdAAtAHMAZQBuAGQALQBlAG0AYQBpAGwALQBzAGEAdQByAGEAdgAuAGsA
YQBzAGgAeQBhAHAAQABxAGwAbwBnAGkAYwAuAGMAbwBtAD4AIAA8ADEANAAwADAAOAAxADQAMAAx
ADIALgA5ADUAOQA1AC4AMwA3AC4AYwBhAG0AZQBsAEAAaABhAGEAawBvAG4AMwAuAHIAaQBzAGkA
bgBnAHQAaQBkAGUAcwB5AHMAdABlAG0AcwAuAGMAbwBtAD4AAAADAN4/n04AAEAABzBZKngEpnrP
AQMAJgAAAAAAAgFHAAEAAAAvAAAAYz1VUzthPSA7cD1RTG9naWM7bD1BVk1CMi0xNDA1MjgxODUy
NDdaLTIyMzg2OQAAHwAVEAEAAABYAAAANgA4ADQANgA4ADQAQwA0ADQAQQBCADEAOQA1ADQARQBC
ADMANwA0AEUANQBBADUAMQA5ADkANgBCADQAQwBDAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAIB
FDABAAAADAAAAAUCAAAmLQ1hTgAAAB8A+j8BAAAAFgAAAFEAdQBpAG4AbgAgAFQAcgBhAG4AAAAA
AB8AAICGAwIAAAAAAMAAAAAAAABGAQAAABYAAAB1AHMAZQByAC0AYQBnAGUAbgB0AAAAAAABAAAA
RgAAAE0AaQBjAHIAbwBzAG8AZgB0AC0ATQBhAGMATwB1AHQAbABvAG8AawAvADEANAAuADQALgAx
AC4AMQA0ADAAMwAyADYAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUA
cgBzAGEAdABpAG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAABCAQAASQBJ
AD0AMAAxADAAMQBDAEYANwBBAEEANgAwADQARAAwAEQAMwA5ADEARQA0AEUANQA2ADMAMABEADQA
NQBCAEEAQwA0ADIARgAwADkAOAAwAEYANQBGAEUANQA0ADsAUwBCAE0ASQBEAD0AMwA7AFMAMQA9
ADwAMQA0ADAAMAA4ADEANAAwADEAMgAuADkANQA5ADUALgAzADcALgBjAGEAbQBlAGwAQABoAGEA
YQBrAG8AbgAzAC4AcgBpAHMAaQBuAGcAdABpAGQAZQBzAHkAcwB0AGUAbQBzAC4AYwBvAG0APgA7
AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMgAgACgAQgB1AGkAbABkACAA
MwA4ADcALgAwACkALAAgAFMAdABhAGcAZQA9AEgAMgAAAAAAAwANNP0/AAAfAACAhgMCAAAAAADA
AAAAAAAARgEAAAAgAAAAeAAtAG0AcwAtAGgAYQBzAC0AYQB0AHQAYQBjAGgAAAABAAAAAgAAAAAA
AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAiAAAAeAAtAG8AcgBpAGcAaQBuAGEAdABpAG4AZwAt
AGkAcAAAAAAAAQAAABoAAABbADEAMAAuADMALgAxADAALgA4ADEAXQAAAAAAiJA=

--_000_504EB66DAC8D234EB8E8560985C2D7AD46D09012avmb2qlogicorg_--
