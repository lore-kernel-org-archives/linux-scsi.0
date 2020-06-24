Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EE1C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 03:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 330EB20CC7
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 03:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388356AbgFXDKI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 23:10:08 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43764 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387985AbgFXDKI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 23:10:08 -0400
Received: by mail-pl1-f193.google.com with SMTP id g12so409755pll.10
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2020 20:10:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jDuQ8YZ8Sw6TXaHxYXXfM3NjHzFOPF3o3eqRspL92js=;
        b=rZqluHCspyoKpdsOdvyTxF+P6LVF59OOLHFdGJQTM9oorZmRweR3RJr9eBgAsrLO+4
         7bW7iBACRhJ4uKLJM3N14HGBn63U907IumdOKWQmD5iJ+wQAnqGRPi8mNjPsNkYk1cQd
         8ifNARwEvTGrR6LDamTYa83VyrPHAxBQnt1JR9rYb0l8+xLnOxjifYIAzP/LW7JBAfgU
         y8LTirfTxr3qaSqV8Aek1n5kUKCaVDzV/AMVKbkTnl19ylBXgfxPUx6UGmmrlGTbF+FC
         jOQBsYsM8B6hRd2tlME8UD6TFVw13zxv1lcjsqAj9ZSBtWV8ib2hd2vMb6LUkaVRgvP1
         r1gQ==
X-Gm-Message-State: AOAM531o2XYewnR5uHK4ojoPyGjZAIr0KsBLQywZfgxbg1OdetS8GAXc
        GvY5EzhaVlbRXNlCpNsOwIE=
X-Google-Smtp-Source: ABdhPJwWUvYEd71F6TOZqkAjgTIiAyQAeMkDeh/7emD/h5S6gQyWrQpOkyUVHMMyjQwyreJIsXa1Vg==
X-Received: by 2002:a17:90a:266f:: with SMTP id l102mr1608803pje.144.1592968205797;
        Tue, 23 Jun 2020 20:10:05 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id x8sm3801429pje.31.2020.06.23.20.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 20:10:05 -0700 (PDT)
Subject: Re: [RFC PATCH v1 2/2] exynos-ufs: support command history
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org
References: <1592635992-35619-1-git-send-email-kwmad.kim@samsung.com>
 <CGME20200620070047epcas2p37229d52d479df9f64ee4fc14f469acf9@epcas2p3.samsung.com>
 <1592635992-35619-2-git-send-email-kwmad.kim@samsung.com>
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
Message-ID: <6eaeed01-9c1b-1bf2-8375-568d24f079e3@acm.org>
Date:   Tue, 23 Jun 2020 20:10:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1592635992-35619-2-git-send-email-kwmad.kim@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +#define EN_PRINT_UFS_LOG 1

Since this macro controls debug code, please make this configurable at
runtime, e.g. as a kernel module parameter or by using the dynamic debug
mechanism.

> +/* Structure for ufs cmd logging */
> +#define MAX_CMD_LOGS    32

Please clarify in the comment above this constant how this constant has
been chosen. Is this constant e.g. related to the queue depth? Is this
constant per UFS device or is it a maximum for all UFS devices?

> +struct cmd_data {
> +	unsigned int tag;
> +	unsigned int sct;
> +	unsigned long lba;
> +	u64 start_time;
> +	u64 end_time;
> +	u64 outstanding_reqs;
> +	int retries;
> +	unsigned char op;
> +};

Please use data types that explicitly specify the width for members like
e.g. the lba (u64 instead of unsigned long). Please also use u8 instead
of unsigned char for 'op' since 'op' is not used to store any kind of
ASCII character.

> +struct ufs_cmd_info {
> +	u32 total;
> +	u32 last;
> +	struct cmd_data data[MAX_CMD_LOGS];
> +	struct cmd_data *pdata[32];	/* Currently, 32 slots */
> +};

What are 'slots'? Why 32?

> +#define DBG_NUM_OF_HOSTS	1
> +struct ufs_s_dbg_mgr {
> +	struct ufs_exynos_handle *handle;
> +	int active;
> +	u64 first_time;
> +	u64 time;
> +
> +	/* cmd log */
> +	struct ufs_cmd_info cmd_info;
> +	struct cmd_data cmd_log;		/* temp buffer to put */
> +	spinlock_t cmd_lock;
> +};

Please add a comment above this structure that explains the role of this
data structure.

> +static struct ufs_s_dbg_mgr ufs_s_dbg[DBG_NUM_OF_HOSTS];

A static array? That's suspicious. Should that array perhaps be a member
of another UFS data structure, e.g. the UFS host or device data structure?

> +static int ufs_s_dbg_mgr_idx;

What does this variable represent?

> +	for (i = 0 ; i < max ; i++, data++) {
> +		dev_err(dev, ": 0x%02x, %02d, 0x%08lx, 0x%04x, %d, %llu, %llu, 0x%llx %s",
> +				data->op,
> +				data->tag,
> +				data->lba,
> +				data->sct,
> +				data->retries,
> +				data->start_time,
> +				data->end_time,
> +				data->outstanding_reqs,
> +				((last == i) ? "<--" : " "));

Please follow the same coding style as elsewhere in the Linux kernel and
specify multiple arguments per line (up to the current column limit).
Please also align the arguments either with the opening parentheses or
indent these by one tab as requested in the Linux kernel coding style
document.

> +/*
> + * EXTERNAL FUNCTIONS
> + *
> + * There are two classes that are to initialize data structures for debug
> + * and to define actual behavior.
> + */
> +void exynos_ufs_dump_info(struct ufs_exynos_handle *handle, struct device *dev)
> +{
> +	struct ufs_s_dbg_mgr *mgr = (struct ufs_s_dbg_mgr *)handle->private;
> +
> +	if (mgr->active == 0)
> +		goto out;
> +
> +	mgr->time = cpu_clock(raw_smp_processor_id());
> +
> +#if EN_PRINT_UFS_LOG
> +	ufs_s_print_cmd_log(mgr, dev);
> +#endif
> +
> +	if (mgr->first_time == 0ULL)
> +		mgr->first_time = mgr->time;
> +out:
> +	return;
> +}

Using cpu_clock() without storing the CPU on which it has been sampled
seems wrong to me. Is higher accuracy than a single jiffy required? If
not, how about using 'jiffies' instead? From clock.h:

/*
 * As outlined in clock.c, provides a fast, high resolution, nanosecond
 * time source that is monotonic per cpu argument and has bounded drift
 * between cpus.
 *
 * ######################### BIG FAT WARNING ##########################
 * # when comparing cpu_clock(i) to cpu_clock(j) for i != j, time can #
 * # go backwards !!                                                  #
 * ####################################################################
 */

> +void exynos_ufs_cmd_log_start(struct ufs_exynos_handle *handle,
> +			      struct ufs_hba *hba, struct scsi_cmnd *cmd)
> +{
> +	struct ufs_s_dbg_mgr *mgr = (struct ufs_s_dbg_mgr *)handle->private;
> +	int cpu = raw_smp_processor_id();
> +	struct cmd_data *cmd_log = &mgr->cmd_log;	/* temp buffer to put */
> +	unsigned long lba = (cmd->cmnd[2] << 24) |
> +					(cmd->cmnd[3] << 16) |
> +					(cmd->cmnd[4] << 8) |
> +					(cmd->cmnd[5] << 0);
> +	unsigned int sct = (cmd->cmnd[7] << 8) |
> +					(cmd->cmnd[8] << 0);

Aargh! SCSI command parsing ... Has it been considered to use
blk_rq_pos(cmd->req) and blk_rq_bytes(cmd->req) instead?

> +int exynos_ufs_init_dbg(struct ufs_exynos_handle *handle)
> +{
> +	struct ufs_s_dbg_mgr *mgr;
> +
> +	if (ufs_s_dbg_mgr_idx >= DBG_NUM_OF_HOSTS)
> +		return -1;
> +
> +	mgr = &ufs_s_dbg[ufs_s_dbg_mgr_idx++];
> +	handle->private = (void *)mgr;
> +	mgr->handle = handle;
> +	mgr->active = 1;

Can the '(void *)' cast above be left out?

> +#define UFS_VS_MMIO_VER 1

What does this constant represent? Please add a comment.

Thanks,

Bart.
