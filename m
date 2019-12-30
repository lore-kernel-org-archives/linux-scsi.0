Return-Path: <SRS0=iDBg=2U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33646C2D0C0
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 02:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E160B207FD
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Dec 2019 02:47:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fRyzWv9M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfL3Crb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 29 Dec 2019 21:47:31 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43039 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbfL3Crb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Dec 2019 21:47:31 -0500
Received: by mail-ot1-f65.google.com with SMTP id p8so8099920oth.10
        for <linux-scsi@vger.kernel.org>; Sun, 29 Dec 2019 18:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hlAqkKaPuMXzEnEwRu5OwzHOowkg5d+/FHpGz4KcDlM=;
        b=fRyzWv9MRqyoTn0zyGpZcRkjJl+pmLq31pwJOeVLgE294wTcRPGJvS/+z+x0JTBD0S
         i7vgO80i3sRf3+di9DMZLaaIC2PPqvqybe76V0rTbnXmx1KDGKnCIFo3PbTTTwTljXp1
         RBsDi1w/CKTDKP5bKbp7ufkPEiA2h5PtZTg4l/o8VeMJwWmKkgS48PveJeSFBNAM8xLW
         p+69/EqCpiUZlXwMDPfBOTXsW/twjlTxwMrmHaD+BDBJRI/xnxIzkkqiC7PNAyN9/YcI
         kJpI5R8dV3F3tBuheHW62jlsWESNsTWm0u6h7ewVDFzat74g54iPgwKS4a9InHtMhNwz
         m1bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hlAqkKaPuMXzEnEwRu5OwzHOowkg5d+/FHpGz4KcDlM=;
        b=UiKgN/towp3lV49+/orqeokq7npYqonNUbP7mKkl4+Jc9i9vy9FeXJLx6Uubp94liT
         VCFL6mybxsXbp9txruil7IRpSWV05BEiyGGaGQKSodRpYPA0IELRs2omnLxr5L1P9lO9
         D3Bd89QSJjMYMMRAWP2fSsaqx8qGF2+9nXYiIO5isD3fK3xNRTli58QKo4nuxxL4OtFT
         UtcQPfiZbIpR4jLSZyuhX+uJQYdXRHlmkxrZaEHN1KPNlXksbQBLnt8HFu5xOV4GRYF6
         xv/x4AZ+DZLZvhmnSaX9epyJA+AujOBSg+84dnUbCcIz+/zDm8Th9DsjfudkA40zynm5
         t4ig==
X-Gm-Message-State: APjAAAVny2WPtp/M8/lVIJTHe/KimhgnGm2LORFlYB+bAgfXREF8ldKB
        v9zlszLsh0sj1S3yrMuSIX0=
X-Google-Smtp-Source: APXvYqxU7YEIDFHNubZYEMdjcezXnDNAsqD8y1mZFEUbxEoU2NDi/9xl0e8/1RTRDe4deYl60VUSGw==
X-Received: by 2002:a05:6830:18e9:: with SMTP id d9mr62524329otf.332.1577674050090;
        Sun, 29 Dec 2019 18:47:30 -0800 (PST)
Received: from ubuntu-m2-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id e17sm15250028otq.58.2019.12.29.18.47.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 29 Dec 2019 18:47:29 -0800 (PST)
Date:   Sun, 29 Dec 2019 19:47:28 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     linux-scsi@vger.kernel.org,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        jinpu.wang@profitbricks.com, martin.petersen@oracle.com,
        dpf@google.com, yuuzheng@google.com, auradkar@google.com,
        vishakhavc@google.com, bjashnani@google.com, radha@google.com,
        akshatzen@google.com, clang-built-linux@google.com
Subject: Re: [PATCH 09/12] pm80xx : IOCTL functionality for SGPIO.
Message-ID: <20191230024728.GA693@ubuntu-m2-xlarge-x86>
References: <20191224044143.8178-1-deepak.ukey@microchip.com>
 <20191224044143.8178-10-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224044143.8178-10-deepak.ukey@microchip.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Deepak,

The 0day bot reported an issue with this patch with Clang, would you
mind taking a look at it? The full report is attached at the bottom,
I've added a comment inline before it though.

On Tue, Dec 24, 2019 at 10:11:40AM +0530, Deepak Ukey wrote:
> From: Deepak Ukey <Deepak.Ukey@microchip.com>
> 
> Added the IOCTL functionality for SGPIO.
> 
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: Akshat Jain <akshatzen@google.com>
> Signed-off-by: Yu Zheng <yuuzheng@google.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c  |  73 ++++++++++++++++
>  drivers/scsi/pm8001/pm8001_ctl.h  |  72 ++++++++++++++++
>  drivers/scsi/pm8001/pm8001_hwi.c  | 172 +++++++++++++++++++++++++++++++++++++-
>  drivers/scsi/pm8001/pm8001_hwi.h  |  17 ++++
>  drivers/scsi/pm8001/pm8001_init.c |   3 +
>  drivers/scsi/pm8001/pm8001_sas.c  |  37 ++++++++
>  drivers/scsi/pm8001/pm8001_sas.h  |  20 +++++
>  drivers/scsi/pm8001/pm80xx_hwi.c  |   6 ++
>  drivers/scsi/pm8001/pm80xx_hwi.h  |   3 +
>  9 files changed, 402 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 8292074c1e6f..3e59b2a7185a 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -1009,6 +1009,76 @@ static long pm8001_gpio_ioctl(struct pm8001_hba_info *pm8001_ha,
>  	return ret;
>  }
>  
> +static long pm8001_sgpio_ioctl(struct pm8001_hba_info *pm8001_ha,
> +		unsigned long arg)
> +{
> +	struct sgpio_buffer buffer;
> +	struct read_write_req_resp *req = &buffer.sgpio_req;
> +	struct sgpio_req payload;
> +	struct sgpio_ioctl_resp *sgpio_resp;
> +	DECLARE_COMPLETION_ONSTACK(completion);
> +	unsigned long timeout;
> +	u32 ret = 0, i;
> +
> +	if (copy_from_user(&buffer, (struct sgpio_buffer *)arg,
> +		sizeof(struct sgpio_buffer))) {
> +		return ADPT_IOCTL_CALL_FAILED;
> +	}
> +	mutex_lock(&pm8001_ha->ioctl_mutex);
> +	pm8001_ha->ioctl_completion = &completion;
> +
> +	payload.func_reg_index = cpu_to_le32((req->register_index << 24) |
> +			(req->register_type << 16) | (req->function << 8) |
> +			SMP_FRAME_REQ);
> +	payload.count = req->register_count;
> +
> +	if (req->function == WRITE_SGPIO_REGISTER) {
> +		if (req->register_count > MAX_SGPIO_REQ_PAYLOAD) {
> +			ret = ADPT_IOCTL_CALL_FAILED;
> +			goto exit;
> +		}
> +		for (i = 0; i < req->register_count; i++)
> +			payload.value[i] = req->read_write_data[i];
> +	}
> +
> +	ret = PM8001_CHIP_DISP->sgpio_req(pm8001_ha, &payload);
> +	if (ret != 0) {
> +		ret = ADPT_IOCTL_CALL_FAILED;
> +		goto exit;
> +	}

timeout is uninitialized here; could this if statement be removed and
have the msecs_to_jiffies just hardcode the 2000?

> +	if (timeout < 2000)
> +		timeout = 2000;
> +
> +	timeout = wait_for_completion_timeout(&completion,
> +			msecs_to_jiffies(timeout));
> +	if (timeout == 0) {
> +		ret = ADPT_IOCTL_CALL_TIMEOUT;
> +		goto exit;
> +	}
> +
> +	sgpio_resp = &pm8001_ha->sgpio_resp;
> +	req->frame_type		= sgpio_resp->func_result & 0xff;
> +	req->function		= (sgpio_resp->func_result >> 8) & 0xff;
> +	req->function_result	= (sgpio_resp->func_result >> 16) & 0xff;
> +	if (req->function == READ_SGPIO_REGISTER) {
> +		for (i = 0; i < req->register_count; i++)
> +			req->read_write_data[i] = sgpio_resp->value[i];
> +	}
> +	ret = ADPT_IOCTL_CALL_SUCCESS;
> +exit:
> +	spin_lock_irq(&pm8001_ha->ioctl_lock);
> +	pm8001_ha->ioctl_completion = NULL;
> +	spin_unlock_irq(&pm8001_ha->ioctl_lock);
> +	buffer.header.return_code = ret;
> +	if (copy_to_user((void *)arg, (void *)&buffer,
> +			sizeof(struct sgpio_buffer))) {
> +		ret = ADPT_IOCTL_CALL_FAILED;
> +	}
> +	mutex_unlock(&pm8001_ha->ioctl_mutex);
> +
> +	return ret;
> +}
> +
>  static int pm8001_ioctl_get_phy_profile(struct pm8001_hba_info *pm8001_ha,
>  		unsigned long arg)
>  {
> @@ -1172,6 +1242,9 @@ static long pm8001_ioctl(struct file *file,
>  	case ADPT_IOCTL_GPIO:
>  		ret = pm8001_gpio_ioctl(pm8001_ha, arg);
>  		break;
> +	case ADPT_IOCTL_SGPIO:
> +		ret = pm8001_sgpio_ioctl(pm8001_ha, arg);
> +		break;
>  	case ADPT_IOCTL_GET_PHY_PROFILE:
>  		ret = pm8001_ioctl_get_phy_profile(pm8001_ha, arg);
>  		return ret;

On Thu, Dec 26, 2019 at 06:16:43AM +0800, kbuild test robot wrote:
> CC: kbuild-all@lists.01.org
> In-Reply-To: <20191224044143.8178-10-deepak.ukey@microchip.com>
> References: <20191224044143.8178-10-deepak.ukey@microchip.com>
> TO: Deepak Ukey <deepak.ukey@microchip.com>
> CC: linux-scsi@vger.kernel.org
> CC: Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com, deepak.ukey@microchip.com, jinpu.wang@profitbricks.com, martin.petersen@oracle.com, dpf@google.com, yuuzheng@google.com, auradkar@google.com, vishakhavc@google.com, bjashnani@google.com, radha@google.com, akshatzen@google.com
> 
> Hi Deepak,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on mkp-scsi/for-next]
> [cannot apply to scsi/for-next v5.5-rc3 next-20191220]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Deepak-Ukey/pm80xx-Updates-for-the-driver-version-0-1-39/20191225-181036
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
> config: x86_64-allyesconfig (attached as .config)
> compiler: clang version 10.0.0 (git://gitmirror/llvm_project 9a77c2095439ba41bd8f6f35931b94075b2fd45b)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from drivers/scsi/pm8001/pm8001_ctl.c:43:
>    In file included from drivers/scsi/pm8001/pm8001_sas.h:58:
>    drivers/scsi/pm8001/pm8001_defs.h:102:9: warning: 'CONFIG_SCSI_PM8001_MAX_DMA_SG' macro redefined [-Wmacro-redefined]
>    #define CONFIG_SCSI_PM8001_MAX_DMA_SG   528
>            ^
>    ./include/generated/autoconf.h:10861:9: note: previous definition is here
>    #define CONFIG_SCSI_PM8001_MAX_DMA_SG 128
>            ^
> >> drivers/scsi/pm8001/pm8001_ctl.c:1049:6: warning: variable 'timeout' is uninitialized when used here [-Wuninitialized]
>            if (timeout < 2000)
>                ^~~~~~~
>    drivers/scsi/pm8001/pm8001_ctl.c:1020:23: note: initialize the variable 'timeout' to silence this warning
>            unsigned long timeout;
>                                 ^
>                                  = 0
>    2 warnings generated.
> 
> vim +/timeout +1049 drivers/scsi/pm8001/pm8001_ctl.c
> 
>   1011	
>   1012	static long pm8001_sgpio_ioctl(struct pm8001_hba_info *pm8001_ha,
>   1013			unsigned long arg)
>   1014	{
>   1015		struct sgpio_buffer buffer;
>   1016		struct read_write_req_resp *req = &buffer.sgpio_req;
>   1017		struct sgpio_req payload;
>   1018		struct sgpio_ioctl_resp *sgpio_resp;
>   1019		DECLARE_COMPLETION_ONSTACK(completion);
>   1020		unsigned long timeout;
>   1021		u32 ret = 0, i;
>   1022	
>   1023		if (copy_from_user(&buffer, (struct sgpio_buffer *)arg,
>   1024			sizeof(struct sgpio_buffer))) {
>   1025			return ADPT_IOCTL_CALL_FAILED;
>   1026		}
>   1027		mutex_lock(&pm8001_ha->ioctl_mutex);
>   1028		pm8001_ha->ioctl_completion = &completion;
>   1029	
>   1030		payload.func_reg_index = cpu_to_le32((req->register_index << 24) |
>   1031				(req->register_type << 16) | (req->function << 8) |
>   1032				SMP_FRAME_REQ);
>   1033		payload.count = req->register_count;
>   1034	
>   1035		if (req->function == WRITE_SGPIO_REGISTER) {
>   1036			if (req->register_count > MAX_SGPIO_REQ_PAYLOAD) {
>   1037				ret = ADPT_IOCTL_CALL_FAILED;
>   1038				goto exit;
>   1039			}
>   1040			for (i = 0; i < req->register_count; i++)
>   1041				payload.value[i] = req->read_write_data[i];
>   1042		}
>   1043	
>   1044		ret = PM8001_CHIP_DISP->sgpio_req(pm8001_ha, &payload);
>   1045		if (ret != 0) {
>   1046			ret = ADPT_IOCTL_CALL_FAILED;
>   1047			goto exit;
>   1048		}
> > 1049		if (timeout < 2000)
>   1050			timeout = 2000;
>   1051	
>   1052		timeout = wait_for_completion_timeout(&completion,
>   1053				msecs_to_jiffies(timeout));
>   1054		if (timeout == 0) {
>   1055			ret = ADPT_IOCTL_CALL_TIMEOUT;
>   1056			goto exit;
>   1057		}
>   1058	
>   1059		sgpio_resp = &pm8001_ha->sgpio_resp;
>   1060		req->frame_type		= sgpio_resp->func_result & 0xff;
>   1061		req->function		= (sgpio_resp->func_result >> 8) & 0xff;
>   1062		req->function_result	= (sgpio_resp->func_result >> 16) & 0xff;
>   1063		if (req->function == READ_SGPIO_REGISTER) {
>   1064			for (i = 0; i < req->register_count; i++)
>   1065				req->read_write_data[i] = sgpio_resp->value[i];
>   1066		}
>   1067		ret = ADPT_IOCTL_CALL_SUCCESS;
>   1068	exit:
>   1069		spin_lock_irq(&pm8001_ha->ioctl_lock);
>   1070		pm8001_ha->ioctl_completion = NULL;
>   1071		spin_unlock_irq(&pm8001_ha->ioctl_lock);
>   1072		buffer.header.return_code = ret;
>   1073		if (copy_to_user((void *)arg, (void *)&buffer,
>   1074				sizeof(struct sgpio_buffer))) {
>   1075			ret = ADPT_IOCTL_CALL_FAILED;
>   1076		}
>   1077		mutex_unlock(&pm8001_ha->ioctl_mutex);
>   1078	
>   1079		return ret;
>   1080	}
>   1081	
> 
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology Center
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

Cheers,
Nathan
