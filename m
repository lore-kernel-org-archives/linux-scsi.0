From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH 10/20] qla2xxx: Fix interaction issue between qla2xxx
 and Target Core Module
Date: Wed, 9 Dec 2015 22:07:32 +0000
Message-ID: <D28DCE82.1B0CE%quinn.tran@qlogic.com>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-11-git-send-email-himanshu.madhani@qlogic.com>
 <20151208023700.GB9088@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_D28DCE821B0CEquinntranqlogiccom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:25814 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932AbbLIWFt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 17:05:49 -0500
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tB9M3HlL002735
	for <linux-scsi@vger.kernel.org>; Wed, 9 Dec 2015 14:05:49 -0800
Received: from avcashub1.qlogic.com (avcashub3.qlogic.com [198.70.193.117])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1ymgv16944-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 09 Dec 2015 14:05:49 -0800
In-Reply-To: <20151208023700.GB9088@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

--_000_D28DCE821B0CEquinntranqlogiccom_
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <C3EC002B8F656441B4F4FEE84C5732DE@qlogic.com>
Content-Transfer-Encoding: quoted-printable


On 12/7/15, 6:37 PM, "target-devel-owner@vger.kernel.org on behalf of
Christoph Hellwig" <target-devel-owner@vger.kernel.org on behalf of
hch@infradead.org> wrote:

>> -void qlt_abort_cmd(struct qla_tgt_cmd *cmd)
>> +int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
>>  {
>>  	struct qla_tgt *tgt =3D cmd->tgt;
>>  	struct scsi_qla_host *vha =3D tgt->vha;
>>  	struct se_cmd *se_cmd =3D &cmd->se_cmd;
>> +	unsigned long flags,refcount;
>> =20
>>  	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf014,
>>  	    "qla_target(%d): terminating exchange for aborted cmd=3D%p "
>>  	    "(se_cmd=3D%p, tag=3D%llu)", vha->vp_idx, cmd, &cmd->se_cmd,
>>  	    se_cmd->tag);
>> =20
>> +    spin_lock_irqsave(&cmd->cmd_lock, flags);
>> +    if (cmd->aborted) {
>> +        spin_unlock_irqrestore(&cmd->cmd_lock, flags);
>> +
>> +        /* It's normal to see 2 calls in this path:
>> +         *  1) XFER Rdy completion + CMD_T_ABORT
>> +         *  2) TCM TMR - drain_state_list
>> +         */
>> +        refcount =3D atomic_read(&cmd->se_cmd.cmd_kref.refcount);
>> +        ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
>> +               "multiple abort. %p refcount %lx"
>> +               "transport_state %x, t_state %x, se_cmd_flags %x \n",
>> +               cmd, refcount,cmd->se_cmd.transport_state,
>> +               cmd->se_cmd.t_state,cmd->se_cmd.se_cmd_flags);
>> +
>> +        return EIO;
>> +    }
>
>Err, no.  Looking into the refcount inside a kref is never the
>right thing to do.

QT> even for debug purpose??

>
>> +typedef enum {
>> +	/*
>> +	 * BIT_0 - Atio Arrival / schedule to work
>> +	 * BIT_1 - qlt_do_work
>> +	 * BIT_2 - qlt_do work failed
>> +	 * BIT_3 - xfer rdy/tcm_qla2xxx_write_pending
>> +	 * BIT_4 - read respond/tcm_qla2xx_queue_data_in
>> +	 * BIT_5 - status respond / tcm_qla2xx_queue_status
>> +	 * BIT_6 - tcm request to abort/Term exchange.
>> +	 *	pre_xmit_response->qlt_send_term_exchange
>> +	 * BIT_7 - SRR received (qlt_handle_srr->qlt_xmit_response)
>> +	 * BIT_8 - SRR received (qlt_handle_srr->qlt_rdy_to_xfer)
>> +	 * BIT_9 - SRR received (qla_handle_srr->qlt_send_term_exchange)
>> +	 * BIT_10 - Data in - hanlde_data->tcm_qla2xxx_handle_data
>> +
>> +	 * BIT_12 - good completion - qlt_ctio_do_completion -->free_cmd
>> +	 * BIT_13 - Bad completion -
>> +	 *	qlt_ctio_do_completion --> qlt_term_ctio_exchange
>> +	 * BIT_14 - Back end data received/sent.
>> +	 * BIT_15 - SRR prepare ctio
>> +	 * BIT_16 - complete free
>> +	 * BIT_17 - flush - qlt_abort_cmd_on_host_reset
>> +	 * BIT_18 - completion w/abort status
>> +	 * BIT_19 - completion w/unknown status
>> +	 * BIT_20 - tcm_qla2xxx_free_cmd
>
>Please use descriptive names for these flags in the source code!

QT> ACK.  We=B9ll change the bits to more descriptive name in a =B3follow o=
n=B2
patch.

>
>> +	BUG_ON(cmd->cmd_flags & BIT_20);
>> +	cmd->cmd_flags |=3D BIT_20;
>> +
>
>And no crazieness like this.  While we're at it: what synchronizes
>access to ->cmd_flags?

QT> These bits provide indication as to where the command has traversed in
the QLA code.  Each bit is set one time. Due to the async nature of the
TMR code, it triggers QLA driver to repeat this specific free path in the
double free case.  This BUG_ON allows us trap it early on.

In one of the corner case (below), I need to overloaded it + lock for the
cleanup process.

>
>> @@ -466,13 +484,25 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t
>>*vha, struct qla_tgt_cmd *cmd,
>>  static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
>>  {
>>  	struct qla_tgt_cmd *cmd =3D container_of(work, struct qla_tgt_cmd,
>>work);
>> +	unsigned long flags;
>> =20
>>  	/*
>>  	 * Ensure that the complete FCP WRITE payload has been received.
>>  	 * Otherwise return an exception via CHECK_CONDITION status.
>>  	 */
>>  	cmd->cmd_in_wq =3D 0;
>> -	cmd->cmd_flags |=3D BIT_11;
>> +
>> +	spin_lock_irqsave(&cmd->cmd_lock, flags);
>> +	cmd->cmd_flags |=3D CMD_FLAG_DATA_WORK;
>> +	if (cmd->aborted) {
>> +		cmd->cmd_flags |=3D CMD_FLAG_DATA_WORK_FREE;
>> +		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
>> +
>> +		tcm_qla2xxx_free_cmd(cmd);
>> +		return;
>> +	}
>> +	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
>
>All these abort flag hacks look very suspicios.  Can you explain the
>exact theory of operation behind them?

QT> The cmd->aborted flag is used to track the CMD_T_ABORT flag at TCM
level.  If the command have been requested to be aborted by TCM or already
aborted, we advance it to the =B3free" state because our hardware have
already started freeing up resources associated to this command/exchange.
In this specific case(above), a XFER RDY was aborted by the TMR.
Returning the cmd to TCM to generate SCSI Status would generate erroneous
HW error due to freed resource.


>
>--
>To unsubscribe from this list: send the line "unsubscribe target-devel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


--_000_D28DCE821B0CEquinntranqlogiccom_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AABzAGkAcAA6AHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAa
DAEAAAAWAAAAUQB1AGkAbgBuACAAVAByAGEAbgAAAAAAHwAfDAEAAAAsAAAAcQB1AGkAbgBuAC4A
dAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAB4MAQAAAAoAAABTAE0AVABQAAAAAAAC
ARkMAQAAAGQAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBRAHUAaQBuAG4AIABUAHIAYQBuAAAA
UwBNAFQAUAAAAHEAdQBpAG4AbgAuAHQAcgBhAG4AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAB
XQEAAAAsAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAPg/
AQAAABYAAABRAHUAaQBuAG4AIABUAHIAYQBuAAAAAAAfACNAAQAAACwAAABxAHUAaQBuAG4ALgB0
AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AIkABAAAACgAAAFMATQBUAFAAAAAAAAIB
+T8BAAAAZAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgFEAdQBpAG4AbgAgAFQAcgBhAG4AAABT
AE0AVABQAAAAcQB1AGkAbgBuAC4AdAByAGEAbgBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAld
AQAAACwAAABxAHUAaQBuAG4ALgB0AHIAYQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAsAQDoB
AAAAHwAaAAEAAAASAAAASQBQAE0ALgBOAG8AdABlAAAAAAADAPE/CQQAAAsAQDoBAAAAAwD9P+QE
AAACAQswAQAAABAAAAC1RNeqWw3MTLL4A+QCNiStAwAXAAEAAABAADkAAKpKAM4y0QFAAAgwX6rT
AM4y0QELAACACCAGAAAAAADAAAAAAAAARgAAAAAUhQAAAQAAAB8AAICGAwIAAAAAAMAAAAAAAABG
AQAAAB4AAABhAGMAYwBlAHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAMAAAAZQBuAC0AVQBT
AAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAABoUAAAAAAAAfADcAAQAAALAAAABSAGUAOgAgAFsA
UABBAFQAQwBIACAAMQAwAC8AMgAwAF0AIABxAGwAYQAyAHgAeAB4ADoAIABGAGkAeAAgAGkAbgB0
AGUAcgBhAGMAdABpAG8AbgAgAGkAcwBzAHUAZQAgAGIAZQB0AHcAZQBlAG4AIABxAGwAYQAyAHgA
eAB4ACAAYQBuAGQAIABUAGEAcgBnAGUAdAAgAEMAbwByAGUAIABNAG8AZAB1AGwAZQAAAB8APQAB
AAAACgAAAFIAZQA6ACAAAAAAAAMANgAAAAAAHwBCEAEAAABMAAAAPAAyADAAMQA1ADEAMgAwADgA
MAAyADMANwAwADAALgBHAEIAOQAwADgAOABAAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAPgAA
AAIBcQABAAAAIAAAAAEB0TFX+5tefbF97mBLm9nPfcVsyUiewOYNAIACUsGAHwBwAAEAAACoAAAA
WwBQAEEAVABDAEgAIAAxADAALwAyADAAXQAgAHEAbABhADIAeAB4AHgAOgAgAEYAaQB4ACAAaQBu
AHQAZQByAGEAYwB0AGkAbwBuACAAaQBzAHMAdQBlACAAYgBlAHQAdwBlAGUAbgAgAHEAbABhADIA
eAB4AHgAIABhAG4AZAAgAFQAYQByAGcAZQB0ACAAQwBvAHIAZQAgAE0AbwBkAHUAbABlAAAAHwA1
EAEAAABOAAAAPABEADIAOABEAEMARQA4ADIALgAxAEIAMABDAEUAJQBxAHUAaQBuAG4ALgB0AHIA
YQBuAEAAcQBsAG8AZwBpAGMALgBjAG8AbQA+AAAAAAAfADkQAQAAAEoBAAA8ADEANAA0ADkANQAz
ADUANwA0ADcALQAyADgANQAwAC0AMQAtAGcAaQB0AC0AcwBlAG4AZAAtAGUAbQBhAGkAbAAtAGgA
aQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAD4AIAA8
ADEANAA0ADkANQAzADUANwA0ADcALQAyADgANQAwAC0AMQAxAC0AZwBpAHQALQBzAGUAbgBkAC0A
ZQBtAGEAaQBsAC0AaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBj
AC4AYwBvAG0APgAgADwAMgAwADEANQAxADIAMAA4ADAAMgAzADcAMAAwAC4ARwBCADkAMAA4ADgA
QABpAG4AZgByAGEAZABlAGEAZAAuAG8AcgBnAD4AAAAAAAMA3j+vbwAAQAAHMN4kygDOMtEBAwAm
AAAAAAACAUcAAQAAAC8AAABjPVVTO2E9IDtwPVFMb2dpYztsPUFWTUIyLTE1MTIwOTIyMDczMlot
MTE0OTE5AAAfABUQAQAAAFgAAABDADMARQBDADAAMAAyAEIAOABGADYANQA2ADQANAAxAEIANABG
ADQARgBFAEUAOAA0AEMANQA3ADMAMgBEAEUAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAgEUMAEA
AAAMAAAACQIAABfza9hPAAAAHwD6PwEAAAAWAAAAUQB1AGkAbgBuACAAVAByAGEAbgAAAAAAHwAA
gIYDAgAAAAAAwAAAAAAAAEYBAAAAFgAAAHUAcwBlAHIALQBhAGcAZQBuAHQAAAAAAAEAAABGAAAA
TQBpAGMAcgBvAHMAbwBmAHQALQBNAGEAYwBPAHUAdABsAG8AbwBrAC8AMQA0AC4ANQAuADUALgAx
ADUAMAA4ADIAMQAAAAAAHwAAgB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMA
YQB0AGkAbwBuAEkAbgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAABwBAABJAEkAPQAw
ADEAMAAxAEQAMQAzADIAQwBEAEMAMQA3AEUAMQA3AEYAQQAxADAAMQBDAEMANAA4ADUANABCADkA
QgBFADIANAA5AEIANQA3AEMAQwBCADAANgBEADIAOwBTAEIATQBJAEQAPQA4ADsAUwAxAD0APAAy
ADAAMQA1ADEAMgAwADgAMAAyADMANwAwADAALgBHAEIAOQAwADgAOABAAGkAbgBmAHIAYQBkAGUA
YQBkAC4AbwByAGcAPgA7AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMwAg
ACgAQgB1AGkAbABkACAAMgAzADUALgAwACkALAAgAFMAdABhAGcAZQA9AEgAMgAAAAMADTT9PwAA
HwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBo
AAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkA
bgBhAHQAaQBuAGcALQBpAHAAAAAAAAEAAAAaAAAAWwAxADAALgA4AC4ANQAuADIANQAwAF0AAAAA
AB8AAICGAwIAAAAAAMAAAAAAAABGAQAAABYAAABkAGkAcwBjAGwAYQBpAG0AZQByAAAAAAABAAAA
DgAAAGIAeQBwAGEAcwBzAAAAAADFsQ==

--_000_D28DCE821B0CEquinntranqlogiccom_--
