Return-Path: <SRS0=HyWO=6K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0B6C55199
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 22:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B0D62075B
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Apr 2020 22:04:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z5cUhERY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgDZWEC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Apr 2020 18:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgDZWEC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Apr 2020 18:04:02 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44833C061A0F;
        Sun, 26 Apr 2020 15:04:02 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x4so17453729wmj.1;
        Sun, 26 Apr 2020 15:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=10nCqrCYFDyrtgChLL6xzRI0axcD1xMee62SXKtI59A=;
        b=Z5cUhERYPECk1zSBRsNqEpfg4QLC+jr6VodoG80Euva8IjlBjoCPLPQ7qYxrFMWJMt
         rgKFzXUrXPd8FaK3VgiPf01BPwVdEmxW9+MkAWGJBWv5/PfPr5eOM7IqXLdw0GWFYeGU
         k5zZuR/wnNFgP5DF4Ms8Ui/rVrirOhYWhQvzMTtDSXOQGDHNcV6YtG0gCjxpM4oreSNV
         WOManQGK0kWbhzjsTn2zxyCtDDdKECulUZ3nAMLis9yMZXujcmBTP+i2Mtmj/O8EmzBJ
         8ewiJc4vXJEEHJCFuO/uMQePXos36VgTfVeCF/WcGZRKudoLz2ZHElDSnCjKDS02J2/y
         fFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=10nCqrCYFDyrtgChLL6xzRI0axcD1xMee62SXKtI59A=;
        b=eBGHtnaIDZorEi7S8ue81SbnJTDYiS3NJYum/2Igy9l/JfhjoJJECDxZuA0om7S6pK
         rbNKQAprxE686dbO1N6qr09BeHrJvkKY1mK2L7c0f7uni2foTJGIFUs3pJtiAVdaPOFI
         ac/OFVf90wFMJtJktaV8RLUue6s1VFdf0mIdD6ezdG2H/6P0Fet/lem2CU+2uvIkQkQW
         FuJ6o2C64Hqx/05wvd8F5ecWF/HEhgpkXotl4zqsyKdU7cHEaysrUxeYoUOtCfMc778v
         WeVi6bSjaN7ai/GSWXE7TmaTw/9O+PykvQUHGgY4x6SbpKNyl2POsR6x196kKeuivXya
         r7OQ==
X-Gm-Message-State: AGi0PuZluek4t8yCibyam8AxpMCmoVYwTswCRKmdMrnMktoJ0REUW628
        qEpSJ4K/BIzH4iVc2if+vtnkrHlm
X-Google-Smtp-Source: APiQypL7N6oX8EuE4UOebcwreaU8Nx4yovgWlwmiqrC1Uyma/1vZuSTDyFfLUdgF4qPRmWECjf6ULw==
X-Received: by 2002:a7b:c3d4:: with SMTP id t20mr23787478wmj.170.1587938640886;
        Sun, 26 Apr 2020 15:04:00 -0700 (PDT)
Received: from [192.168.3.2] (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id g6sm18319434wrw.34.2020.04.26.15.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 15:04:00 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
To:     Bart Van Assche <bvanassche@acm.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-6-beanhuo@micron.com>
 <183528b9-f04b-40f5-269b-5897da113b97@acm.org>
From:   Bean Huo <huobean@gmail.com>
Message-ID: <e53f3b2c-37ec-2bab-83ff-702dd3b2b813@gmail.com>
Date:   Mon, 27 Apr 2020 00:03:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <183528b9-f04b-40f5-269b-5897da113b97@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 25.04.20 20:07, Bart Van Assche wrote:
> On 2020-04-16 13:31, huobean@gmail.com wrote:
>> +static int ufshpb_execute_cmd(struct ufshpb_lu *hpb, unsigned char *cmd)
>> +{
>> +	struct scsi_sense_hdr sshdr;
>> +	struct scsi_device *sdp;
>> +	struct ufs_hba *hba;
>> +	int retries;
>> +	int ret = 0;
>> +
>> +	hba = hpb->hba;
>> +
>> +	sdp = hba->sdev_ufs_lu[hpb->lun];
>> +	if (!sdp) {
>> +		hpb_warn("%s UFSHPB cannot find scsi_device\n",  __func__);
>> +		return -ENODEV;
>> +	}
>> +
>> +	ret = scsi_device_get(sdp);
>> +	if (!ret && !scsi_device_online(sdp)) {
>> +		ret = -ENODEV;
>> +		scsi_device_put(sdp);
>> +		return ret;
>> +	}
>> +
>> +	for (retries = 3; retries > 0; --retries) {
>> +		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
>> +				   msecs_to_jiffies(30000), 3, 0, RQF_PM, NULL);
>> +		if (ret == 0)
>> +			break;
>> +	}
>> +
>> +	if (ret) {
>> +		if (driver_byte(ret) == DRIVER_SENSE &&
>> +		    scsi_sense_valid(&sshdr)) {
>> +			switch (sshdr.sense_key) {
>> +			case ILLEGAL_REQUEST:
>> +				hpb_err("ILLEGAL REQUEST asc=0x%x ascq=0x%x\n",
>> +					sshdr.asc, sshdr.ascq);
>> +				break;
>> +			default:
>> +				hpb_err("Unknown return code = %x\n", ret);
>> +				break;
>> +			}
>> +		}
>> +	}
>> +	scsi_device_put(sdp);
>> +
>> +	return ret;
>> +}
> If scsi_execute() would be changed into asynchronous SCSI command
> submission, can ufshpb_execute_cmd() be called from inside the UFS
> .queue_rq() callback instead of from workqueue context?
>
> The scsi_device_get() call looks misplaced. I think that call should
> happen before schedule_work() is called.
>
>> +static int ufshpb_l2p_load_req(struct ufshpb_lu *hpb, struct request_queue *q,
>> +			       struct ufshpb_map_req *map_req)
>> +{
>> +	struct scsi_request *scsi_rq;
>> +	unsigned char cmd[16] = { };
>> +	struct request *req;
>> +	struct bio *bio;
>> +	int alloc_len;
>> +	int ret;
>> +
>> +	bio = &map_req->bio;
>> +
>> +	ret = ufshpb_add_bio_page(hpb, q, bio, map_req->bvec, map_req->mctx);
>> +	if (ret) {
>> +		hpb_err("ufshpb_add_bio_page() failed with ret %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	alloc_len = hpb->hba->hpb_geo.subregion_entry_sz;
>> +	/*
>> +	 * HPB Sub-Regions are equally sized except for the last one which is
>> +	 * smaller if the last hpb Region is not an integer multiple of
>> +	 * bHPBSubRegionSize.
>> +	 */
>> +	if (map_req->region == (hpb->lu_region_cnt - 1) &&
>> +	    map_req->subregion == (hpb->subregions_in_last_region - 1))
>> +		alloc_len = hpb->last_subregion_entry_size;
>> +
>> +	ufshpb_prepare_read_buf_cmd(cmd, map_req->region, map_req->subregion,
>> +				    alloc_len);
>> +	if (!map_req->req) {
>> +		map_req->req = blk_get_request(q, REQ_OP_SCSI_IN, 0);
>> +		if (IS_ERR(map_req->req))
>> +			return PTR_ERR(map_req->req);
>> +	}
>> +	req = map_req->req;
>> +	scsi_rq = scsi_req(req);
>> +
>> +	blk_rq_append_bio(req, &bio);
>> +
>> +	scsi_req_init(scsi_rq);
>> +
>> +	scsi_rq->cmd_len = COMMAND_SIZE(cmd[0]);
>> +	memcpy(scsi_rq->cmd, cmd, scsi_rq->cmd_len);
>> +	req->timeout = msecs_to_jiffies(30000);
>> +	req->end_io_data = (void *)map_req;
>> +
>> +	hpb_dbg(SCHEDULE_INFO, hpb, "ISSUE READ_BUFFER : (%d-%d) retry = %d\n",
>> +		map_req->region, map_req->subregion, map_req->retry_cnt);
>> +	hpb_trace(hpb, "%s: I RB %d - %d", DRIVER_NAME, map_req->region,
>> +		  map_req->subregion);
>> +
>> +	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_l2p_load_req_done);
>> +	map_req->req_issue_t = ktime_to_ns(ktime_get());
>> +
>> +	atomic64_inc(&hpb->status.map_req_cnt);
>> +
>> +	return 0;
>> +}
> Same question here: if 'req' would be submitted asynchronously, can
> ufshpb_l2p_load_req() be called directly from inside the UFS .queue_rq()
> callback instead of from workqueue context?
>
> Thanks,
>
> Bart.

Hi, Bart
Thanks very much.
If I understood the Christoph's the second question correctly. Enqueue 
HPB requests to the
scsi_device->request_queueu, and fly back to SCSI schedule, it's 
unacceptable. I don't like this
implementation way either. Also, the latency of the L2P table update is 
higher. I will change it
in the RFC patch.

thanks,
Bean
