Return-Path: <SRS0=0MZD=6J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D3FC55191
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Apr 2020 18:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59A5020714
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Apr 2020 18:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbgDYSHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Apr 2020 14:07:46 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:44376 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbgDYSHp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Apr 2020 14:07:45 -0400
Received: by mail-pf1-f169.google.com with SMTP id p25so6456067pfn.11;
        Sat, 25 Apr 2020 11:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=DygkneB8Wo1mZONnIrZ1eQSaeccTjeq3ViwRwwN9bPw=;
        b=Dtld5B3dktwufmphgJx1Baa1L3KJeBd0JtZ9H43YfRLzHSnb5/Rz/7JI0Q9Pt784t0
         KcfcvR6HwTbFMOy0OD3yQcmziinNhPH6c/KGApsdbXRiO3wg0R0JoNoetMMDR2GVkhac
         9qF/1xOuAqQb4Y10Wr0txBEdCtjKhuvQlRgsHxqQEUyULrWaZUIFK284+EE7/lux1NEQ
         XV+mG5eFgxYTIKYxeIfWD+os1b700fjB7uKpMPi7CKN/qACYoKiTeEx3xm15jFYv9SIc
         7GkWOymzFXsQvzOWPGZGkT2tV3tbNa8REhKdZ6OT+PJ4YBmgPmIEpVtZ9IAWHVPmR5U1
         LmxA==
X-Gm-Message-State: AGi0PubZUsUpCGVTAocKXB1fBt/cv/T4M++CpPe4XC5fpq/3C8mN88ND
        O25MAC9g7L/Pw3JgqZV0j3obtbxJEgE=
X-Google-Smtp-Source: APiQypKhXgyyHDuseRPvP/VuJTW7WBQyQsd9eaKCfk5bn11sPToM4I3uAfs09OIB6zGC5bbrIFVmLA==
X-Received: by 2002:a63:dc41:: with SMTP id f1mr15663150pgj.348.1587838062664;
        Sat, 25 Apr 2020 11:07:42 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:9817:f6ce:d8be:3e60? ([2601:647:4000:d7:9817:f6ce:d8be:3e60])
        by smtp.gmail.com with ESMTPSA id h11sm8471825pfo.120.2020.04.25.11.07.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 11:07:41 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] scsi: ufs: UFS Host Performance Booster(HPB)
 driver
To:     huobean@gmail.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200416203126.1210-1-beanhuo@micron.com>
 <20200416203126.1210-6-beanhuo@micron.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <183528b9-f04b-40f5-269b-5897da113b97@acm.org>
Date:   Sat, 25 Apr 2020 11:07:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200416203126.1210-6-beanhuo@micron.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-16 13:31, huobean@gmail.com wrote:
> +static int ufshpb_execute_cmd(struct ufshpb_lu *hpb, unsigned char *cmd)
> +{
> +	struct scsi_sense_hdr sshdr;
> +	struct scsi_device *sdp;
> +	struct ufs_hba *hba;
> +	int retries;
> +	int ret = 0;
> +
> +	hba = hpb->hba;
> +
> +	sdp = hba->sdev_ufs_lu[hpb->lun];
> +	if (!sdp) {
> +		hpb_warn("%s UFSHPB cannot find scsi_device\n",  __func__);
> +		return -ENODEV;
> +	}
> +
> +	ret = scsi_device_get(sdp);
> +	if (!ret && !scsi_device_online(sdp)) {
> +		ret = -ENODEV;
> +		scsi_device_put(sdp);
> +		return ret;
> +	}
> +
> +	for (retries = 3; retries > 0; --retries) {
> +		ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
> +				   msecs_to_jiffies(30000), 3, 0, RQF_PM, NULL);
> +		if (ret == 0)
> +			break;
> +	}
> +
> +	if (ret) {
> +		if (driver_byte(ret) == DRIVER_SENSE &&
> +		    scsi_sense_valid(&sshdr)) {
> +			switch (sshdr.sense_key) {
> +			case ILLEGAL_REQUEST:
> +				hpb_err("ILLEGAL REQUEST asc=0x%x ascq=0x%x\n",
> +					sshdr.asc, sshdr.ascq);
> +				break;
> +			default:
> +				hpb_err("Unknown return code = %x\n", ret);
> +				break;
> +			}
> +		}
> +	}
> +	scsi_device_put(sdp);
> +
> +	return ret;
> +}

If scsi_execute() would be changed into asynchronous SCSI command
submission, can ufshpb_execute_cmd() be called from inside the UFS
.queue_rq() callback instead of from workqueue context?

The scsi_device_get() call looks misplaced. I think that call should
happen before schedule_work() is called.

> +static int ufshpb_l2p_load_req(struct ufshpb_lu *hpb, struct request_queue *q,
> +			       struct ufshpb_map_req *map_req)
> +{
> +	struct scsi_request *scsi_rq;
> +	unsigned char cmd[16] = { };
> +	struct request *req;
> +	struct bio *bio;
> +	int alloc_len;
> +	int ret;
> +
> +	bio = &map_req->bio;
> +
> +	ret = ufshpb_add_bio_page(hpb, q, bio, map_req->bvec, map_req->mctx);
> +	if (ret) {
> +		hpb_err("ufshpb_add_bio_page() failed with ret %d\n", ret);
> +		return ret;
> +	}
> +
> +	alloc_len = hpb->hba->hpb_geo.subregion_entry_sz;
> +	/*
> +	 * HPB Sub-Regions are equally sized except for the last one which is
> +	 * smaller if the last hpb Region is not an integer multiple of
> +	 * bHPBSubRegionSize.
> +	 */
> +	if (map_req->region == (hpb->lu_region_cnt - 1) &&
> +	    map_req->subregion == (hpb->subregions_in_last_region - 1))
> +		alloc_len = hpb->last_subregion_entry_size;
> +
> +	ufshpb_prepare_read_buf_cmd(cmd, map_req->region, map_req->subregion,
> +				    alloc_len);
> +	if (!map_req->req) {
> +		map_req->req = blk_get_request(q, REQ_OP_SCSI_IN, 0);
> +		if (IS_ERR(map_req->req))
> +			return PTR_ERR(map_req->req);
> +	}
> +	req = map_req->req;
> +	scsi_rq = scsi_req(req);
> +
> +	blk_rq_append_bio(req, &bio);
> +
> +	scsi_req_init(scsi_rq);
> +
> +	scsi_rq->cmd_len = COMMAND_SIZE(cmd[0]);
> +	memcpy(scsi_rq->cmd, cmd, scsi_rq->cmd_len);
> +	req->timeout = msecs_to_jiffies(30000);
> +	req->end_io_data = (void *)map_req;
> +
> +	hpb_dbg(SCHEDULE_INFO, hpb, "ISSUE READ_BUFFER : (%d-%d) retry = %d\n",
> +		map_req->region, map_req->subregion, map_req->retry_cnt);
> +	hpb_trace(hpb, "%s: I RB %d - %d", DRIVER_NAME, map_req->region,
> +		  map_req->subregion);
> +
> +	blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_l2p_load_req_done);
> +	map_req->req_issue_t = ktime_to_ns(ktime_get());
> +
> +	atomic64_inc(&hpb->status.map_req_cnt);
> +
> +	return 0;
> +}

Same question here: if 'req' would be submitted asynchronously, can
ufshpb_l2p_load_req() be called directly from inside the UFS .queue_rq()
callback instead of from workqueue context?

Thanks,

Bart.
