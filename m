From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [PATCH v2 06/11] qla2xxx: Add support for Private link
 statistics counters.
Date: Thu, 28 Jan 2016 17:34:25 +0000
Message-ID: <D2CF90B8.D604E%himanshu.madhani@qlogic.com>
References: <1453914218-380-1-git-send-email-himanshu.madhani@qlogic.com>
 <1453914218-380-7-git-send-email-himanshu.madhani@qlogic.com>
 <20160128085921.GK27565@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_D2CF90B8D604Ehimanshumadhaniqlogiccom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:58010 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934134AbcA1Re3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jan 2016 12:34:29 -0500
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u0SHXUdR025200
	for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 09:34:28 -0800
Received: from avcashub1.qlogic.com ([198.186.0.117])
	by mx0a-0016ce01.pphosted.com with ESMTP id 20qq9980kf-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 09:34:27 -0800
In-Reply-To: <20160128085921.GK27565@c203.arch.suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi <linux-scsi@vger.kernel.org>

--_000_D2CF90B8D604Ehimanshumadhaniqlogiccom_
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <1436D2DABB14AD4DA7185E62021EC0F6@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Hi Johannes,




On 1/28/16, 12:59 AM, "Johannes Thumshirn" <jthumshirn@suse.de> wrote:

>On Wed, Jan 27, 2016 at 12:03:33PM -0500, Himanshu Madhani wrote:
>> From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
>>=20
>> Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
>> Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
>> ---
>>  drivers/scsi/qla2xxx/qla_attr.c |    6 ++-
>>  drivers/scsi/qla2xxx/qla_bsg.c  |   61
>>+++++++++++++++++++++++++++++++++++++++
>>  drivers/scsi/qla2xxx/qla_bsg.h  |    1 +
>>  drivers/scsi/qla2xxx/qla_dbg.c  |    2 +-
>>  drivers/scsi/qla2xxx/qla_def.h  |   32 +++++++++++++++++++-
>>  drivers/scsi/qla2xxx/qla_mbx.c  |    3 +-
>>  6 files changed, 99 insertions(+), 6 deletions(-)
>>=20
>> diff --git a/drivers/scsi/qla2xxx/qla_attr.c
>>b/drivers/scsi/qla2xxx/qla_attr.c
>> index fef659a..fadce04 100644
>> --- a/drivers/scsi/qla2xxx/qla_attr.c
>> +++ b/drivers/scsi/qla2xxx/qla_attr.c
>> @@ -1917,7 +1917,8 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
>>  	if (qla2x00_reset_active(vha))
>>  		goto done;
>> =20
>> -	stats =3D dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &stats_dma);
>> +	stats =3D dma_alloc_coherent(&ha->pdev->dev,
>> +	    sizeof(struct link_statistics), &stats_dma, GFP_KERNEL);
>>  	if (stats =3D=3D NULL) {
>>  		ql_log(ql_log_warn, vha, 0x707d,
>>  		    "Failed to allocate memory for stats.\n");
>> @@ -1965,7 +1966,8 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
>>  	do_div(pfc_host_stat->seconds_since_last_reset, HZ);
>> =20
>>  done_free:
>> -        dma_pool_free(ha->s_dma_pool, stats, stats_dma);
>> +	dma_free_coherent(&ha->pdev->dev, sizeof(struct link_statistics),
>> +	    stats, stats_dma);
>>  done:
>>  	return pfc_host_stat;
>>  }
>> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c
>>b/drivers/scsi/qla2xxx/qla_bsg.c
>> index d135d6a..913fef2 100644
>> --- a/drivers/scsi/qla2xxx/qla_bsg.c
>> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
>> @@ -2233,6 +2233,64 @@ qla27xx_get_bbcr_data(struct fc_bsg_job *bsg_job)
>>  }
>> =20
>>  static int
>> +qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
>> +{
>> +	struct Scsi_Host *host =3D bsg_job->shost;
>> +	scsi_qla_host_t *vha =3D shost_priv(host);
>> +	struct qla_hw_data *ha =3D vha->hw;
>> +	struct scsi_qla_host *base_vha =3D pci_get_drvdata(ha->pdev);
>> +	struct link_statistics *stats =3D NULL;
>> +	dma_addr_t stats_dma;
>> +	int rval =3D QLA_FUNCTION_FAILED;
>> +
>> +	if (test_bit(UNLOADING, &vha->dpc_flags))
>> +		goto done;
>> +
>> +	if (unlikely(pci_channel_offline(ha->pdev)))
>> +		goto done;
>> +
>> +	if (qla2x00_reset_active(vha))
>> +		goto done;
>> +
>> +	if (!IS_FWI2_CAPABLE(ha))
>> +		goto done;
>> +
>> +	stats =3D dma_alloc_coherent(&ha->pdev->dev,
>> +		sizeof(struct link_statistics), &stats_dma, GFP_KERNEL);
>> +	if (!stats) {
>> +		ql_log(ql_log_warn, vha, 0x70e2,
>> +		"Failed to allocate memory for stats.\n");
>> +		goto done;
>> +	}
>> +
>> +	memset(stats, 0, sizeof(struct link_statistics));
>> +
>> +	rval =3D qla24xx_get_isp_stats(base_vha, stats, stats_dma);
>> +
>> +	if (rval !=3D QLA_SUCCESS)
>> +		goto done_free;
>> +
>> +	ql_dump_buffer(ql_dbg_user + ql_dbg_verbose, vha, 0x70e3,
>> +	    (uint8_t *)stats, sizeof(struct link_statistics));
>> +
>> +	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
>> +	bsg_job->reply_payload.sg_cnt, stats, sizeof(struct link_statistics));
>> +	bsg_job->reply->reply_payload_rcv_len =3D sizeof(struct
>>link_statistics);
>> +
>> +	bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] =3D EXT_STATUS_O=
K;
>> +
>> +	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
>> +	bsg_job->reply->result =3D DID_OK << 16;
>> +	bsg_job->job_done(bsg_job);
>> +
>> +done_free:
>> +	dma_free_coherent(&ha->pdev->dev, sizeof(struct link_statistics),
>> +		stats, stats_dma);
>> +done:
>> +	return rval;
>> +}
>> +
>> +static int
>>  qla2x00_process_vendor_specific(struct fc_bsg_job *bsg_job)
>>  {
>>  	switch (bsg_job->request->rqst_data.h_vendor.vendor_cmd[0]) {
>> @@ -2296,6 +2354,9 @@ qla2x00_process_vendor_specific(struct fc_bsg_job
>>*bsg_job)
>>  	case QL_VND_GET_BBCR_DATA:
>>  		return qla27xx_get_bbcr_data(bsg_job);
>> =20
>> +	case QL_VND_GET_PRIV_STATS:
>> +		return qla2x00_get_priv_stats(bsg_job);
>> +
>>  	default:
>>  		return -ENOSYS;
>>  	}
>> diff --git a/drivers/scsi/qla2xxx/qla_bsg.h
>>b/drivers/scsi/qla2xxx/qla_bsg.h
>> index 4275177..c40dd8b 100644
>> --- a/drivers/scsi/qla2xxx/qla_bsg.h
>> +++ b/drivers/scsi/qla2xxx/qla_bsg.h
>> @@ -28,6 +28,7 @@
>>  #define QL_VND_GET_FLASH_UPDATE_CAPS    0x15
>>  #define QL_VND_SET_FLASH_UPDATE_CAPS    0x16
>>  #define QL_VND_GET_BBCR_DATA    0x17
>> +#define QL_VND_GET_PRIV_STATS	0x18
>> =20
>>  /* BSG Vendor specific subcode returns */
>>  #define EXT_STATUS_OK			0
>> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c
>>b/drivers/scsi/qla2xxx/qla_dbg.c
>> index 493a3ea81..aa6694b 100644
>> --- a/drivers/scsi/qla2xxx/qla_dbg.c
>> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
>> @@ -32,7 +32,7 @@
>>   * |                              |                    | 0x503d,0x5044
>> |
>>   * |                              |                    |
>>0x507b,0x505f	|
>>   * | Timer Routines               |       0x6012       |
>> |
>> - * | User Space Interactions      |       0x70e65      | 0x7018,0x702e
>> |
>> + * | User Space Interactions      |       0x70e3       | 0x7018,0x702e
>> |
>>   * |				  |		       | 0x7020,0x7024  |
>>   * |                              |                    | 0x7039,0x7045
>> |
>>   * |                              |                    | 0x7073-0x7075
>> |
>> diff --git a/drivers/scsi/qla2xxx/qla_def.h
>>b/drivers/scsi/qla2xxx/qla_def.h
>> index c4bd62a..ceb452d 100644
>> --- a/drivers/scsi/qla2xxx/qla_def.h
>> +++ b/drivers/scsi/qla2xxx/qla_def.h
>> @@ -1254,13 +1254,41 @@ struct link_statistics {
>>  	uint32_t inval_xmit_word_cnt;
>>  	uint32_t inval_crc_cnt;
>>  	uint32_t lip_cnt;
>> -	uint32_t unused1[0x1a];
>> +	uint32_t link_up_cnt;
>> +	uint32_t link_down_loop_init_tmo;
>> +	uint32_t link_down_los;
>> +	uint32_t link_down_loss_rcv_clk;
>> +	uint32_t reserved0[5];
>> +	uint32_t port_cfg_chg;
>> +	uint32_t reserved1[11];
>> +	uint32_t rsp_q_full;
>> +	uint32_t atio_q_full;
>> +	uint32_t drop_ae;
>> +	uint32_t els_proto_err;
>> +	uint32_t reserved2;
>>  	uint32_t tx_frames;
>>  	uint32_t rx_frames;
>>  	uint32_t discarded_frames;
>>  	uint32_t dropped_frames;
>> -	uint32_t unused2[1];
>> +	uint32_t reserved3;
>>  	uint32_t nos_rcvd;
>> +	uint32_t reserved4[4];
>> +	uint32_t tx_prjt;
>> +	uint32_t rcv_exfail;
>> +	uint32_t rcv_abts;
>> +	uint32_t seq_frm_miss;
>> +	uint32_t corr_err;
>> +	uint32_t mb_rqst;
>> +	uint32_t nport_full;
>> +	uint32_t eofa;
>> +	uint32_t reserved5;
>> +	uint32_t fpm_recv_word_cnt_lo;
>> +	uint32_t fpm_recv_word_cnt_hi;
>> +	uint32_t fpm_disc_word_cnt_lo;
>> +	uint32_t fpm_disc_word_cnt_hi;
>> +	uint32_t fpm_xmit_word_cnt_lo;
>> +	uint32_t fpm_xmit_word_cnt_hi;
>> +	uint32_t reserved6[70];
>>  };
>> =20
>>  /*
>> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c
>>b/drivers/scsi/qla2xxx/qla_mbx.c
>> index 4433cfb..3dd3398 100644
>> --- a/drivers/scsi/qla2xxx/qla_mbx.c
>> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
>> @@ -2799,7 +2799,8 @@ qla2x00_get_link_status(scsi_qla_host_t *vha,
>>uint16_t loop_id,
>>  			/* Copy over data -- firmware data is LE. */
>>  			ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1086,
>>  			    "Done %s.\n", __func__);
>> -			dwords =3D offsetof(struct link_statistics, unused1) / 4;
>> +			dwords =3D offsetof(struct link_statistics,
>> +					link_up_cnt) / 4;
>>  			siter =3D diter =3D &stats->link_fail_cnt;
>>  			while (dwords--)
>>  				*diter++ =3D le32_to_cpu(*siter++);
>> --=20
>> 1.7.7
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>Seriously, be more verbose on commit messages.

Thanks for reviews. I will make sure in future we will put more details
into commit messages.

>
>Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>--=20
>Johannes Thumshirn                                          Storage
>jthumshirn@suse.de                                +49 911 74053 689
>SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
>GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
>HRB 21284 (AG N=FCrnberg)
>Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850


--_000_D2CF90B8D604Ehimanshumadhaniqlogiccom_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
TQBhAGQAaABhAG4AaQAAAFMATQBUAFAAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABoAGEAbgBp
AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AAl0BAAAAOAAAAGgAaQBtAGEAbgBzAGgAdQAuAG0A
YQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwDlXwEAAABAAAAAcwBpAHAAOgBo
AGkAbQBhAG4AcwBoAHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8A
GgwBAAAAIgAAAEgAaQBtAGEAbgBzAGgAdQAgAE0AYQBkAGgAYQBuAGkAAAAAAB8AHwwBAAAAOAAA
AGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAA
HwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAAB8AAAAAAAAAIErH6S+oxAZnW4A3QEPVAIA
AACASABpAG0AYQBuAHMAaAB1ACAATQBhAGQAaABhAG4AaQAAAFMATQBUAFAAAABoAGkAbQBhAG4A
cwBoAHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AAV0BAAAAOAAA
AGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAA
HwD4PwEAAAAiAAAASABpAG0AYQBuAHMAaAB1ACAATQBhAGQAaABhAG4AaQAAAAAAHwAjQAEAAAA4
AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0A
AAAfACJAAQAAAAoAAABTAE0AVABQAAAAAAACAfk/AQAAAHwAAAAAAAAAgSsfpL6jEBmdbgDdAQ9U
AgAAAIBIAGkAbQBhAG4AcwBoAHUAIABNAGEAZABoAGEAbgBpAAAAUwBNAFQAUAAAAGgAaQBtAGEA
bgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAJXQEAAAA4
AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0A
AAALAEA6AQAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwDxPwkEAAALAEA6AQAA
AAMA/T/kBAAAAgELMAEAAAAQAAAA6YkzXUS69k6iNMzW2R4bfgMAFwABAAAAQAA5AIBmiCHyWdEB
QAAIMObKFCLyWdEBCwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAFIUAAAEAAAAfAACAhgMCAAAAAADA
AAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAADAAAAGUA
bgAtAFUAUwAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAAHwA3AAEAAACgAAAAUgBl
ADoAIABbAFAAQQBUAEMASAAgAHYAMgAgADAANgAvADEAMQBdACAAcQBsAGEAMgB4AHgAeAA6ACAA
QQBkAGQAIABzAHUAcABwAG8AcgB0ACAAZgBvAHIAIABQAHIAaQB2AGEAdABlACAAbABpAG4AawAg
AHMAdABhAHQAaQBzAHQAaQBjAHMAIABjAG8AdQBuAHQAZQByAHMALgAAAB8APQABAAAACgAAAFIA
ZQA6ACAAAAAAAAMANgAAAAAAHwBCEAEAAABWAAAAPAAyADAAMQA2ADAAMQAyADgAMAA4ADUAOQAy
ADEALgBHAEsAMgA3ADUANgA1AEAAYwAyADAAMwAuAGEAcgBjAGgALgBzAHUAcwBlAC4AZABlAD4A
AAAAAAIBcQABAAAAIAAAAAEB0Vkqk5fXaaTcb8NAoko5LLz6oFGfESghgIAACcYAHwBwAAEAAACY
AAAAWwBQAEEAVABDAEgAIAB2ADIAIAAwADYALwAxADEAXQAgAHEAbABhADIAeAB4AHgAOgAgAEEA
ZABkACAAcwB1AHAAcABvAHIAdAAgAGYAbwByACAAUAByAGkAdgBhAHQAZQAgAGwAaQBuAGsAIABz
AHQAYQB0AGkAcwB0AGkAYwBzACAAYwBvAHUAbgB0AGUAcgBzAC4AAAAfADUQAQAAAFoAAAA8AEQA
MgBDAEYAOQAwAEIAOAAuAEQANgAwADQARQAlAGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBu
AGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAD4AAAAAAB8AORABAAAATgEAADwAMQA0ADUAMwA5ADEA
NAAyADEAOAAtADMAOAAwAC0AMQAtAGcAaQB0AC0AcwBlAG4AZAAtAGUAbQBhAGkAbAAtAGgAaQBt
AGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAD4AIAA8ADEA
NAA1ADMAOQAxADQAMgAxADgALQAzADgAMAAtADcALQBnAGkAdAAtAHMAZQBuAGQALQBlAG0AYQBp
AGwALQBoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABoAGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8A
bQA+ACAAPAAyADAAMQA2ADAAMQAyADgAMAA4ADUAOQAyADEALgBHAEsAMgA3ADUANgA1AEAAYwAy
ADAAMwAuAGEAcgBjAGgALgBzAHUAcwBlAC4AZABlAD4AAAAAAAMA3j+vbwAAQAAHMGpFCyLyWdEB
AwAmAAAAAAACAUcAAQAAAC8AAABjPVVTO2E9IDtwPVFMb2dpYztsPUFWTUIzLTE2MDEyODE3MzQy
NVotMTMzNzI3AAAfABUQAQAAAFgAAAAxADQAMwA2AEQAMgBEAEEAQgBCADEANABBAEQANABEAEEA
NwAxADgANQBFADYAMgAwADIAMQBFAEMAMABGADYAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAgEU
MAEAAAAMAAAAMwIAAHqs301IAAAAHwD6PwEAAAAiAAAASABpAG0AYQBuAHMAaAB1ACAATQBhAGQA
aABhAG4AaQAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAFgAAAHUAcwBlAHIALQBhAGcAZQBu
AHQAAAAAAAEAAABGAAAATQBpAGMAcgBvAHMAbwBmAHQALQBNAGEAYwBPAHUAdABsAG8AbwBrAC8A
MQA0AC4ANQAuADkALgAxADUAMQAxADEAOQAAAAAAHwAAgB+k6zOoei5Cvnt54amOVLMBAAAAOAAA
AEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4AAAA
AQAAACgBAABJAEkAPQAwADEAMAAxAEQAMQA1ADkARgAyADIAMgA5AEYANQAyAEQAMgBCADAANQBG
AEMAQQA0ADUANAAzAEEAMgA5AEIAQQA2ADUAQgA0AEYAOAA3ADAAMQA3ADIAOwBTAEIATQBJAEQA
PQAyADIAOwBTADEAPQA8ADIAMAAxADYAMAAxADIAOAAwADgANQA5ADIAMQAuAEcASwAyADcANQA2
ADUAQABjADIAMAAzAC4AYQByAGMAaAAuAHMAdQBzAGUALgBkAGUAPgA7AFYAZQByAHMAaQBvAG4A
PQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMwAgACgAQgB1AGkAbABkACAAMgAzADUALgAwACkALAAg
AFMAdABhAGcAZQA9AEgAMgAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgA
LQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAA
AAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAAAAEAAAAeAAAA
WwAxADAALgAyADkALgAxADAAMgAuADMAMQBdAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAW
AAAAZABpAHMAYwBsAGEAaQBtAGUAcgAAAAAAAQAAAA4AAABiAHkAcABhAHMAcwAAAAAA0/s=

--_000_D2CF90B8D604Ehimanshumadhaniqlogiccom_--
