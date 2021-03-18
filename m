Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2320FC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 01:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC7F064E64
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 01:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhCRBdW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 21:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhCRBdJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 21:33:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8BBC06174A;
        Wed, 17 Mar 2021 18:33:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so2282833pjv.1;
        Wed, 17 Mar 2021 18:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DPWhA4Bdk7YoqJ/5PFItADTPFceUHiMZjzWCHLbK46s=;
        b=CVI4OLShx44jnJ7Wa3x5KSn7TQRo5qeao5hmmna4USvYzHKamYdCTqUrt0FtcgKuK7
         aD4KA59KBsHgbrSZ7l7BcXB+tKtWzGbNqYZ5EafuyvuO5DLAc4+59C76uJlVxNmv5RMI
         bKfOTZHW0cVGPdTa9WZUBd72y8RMdEzCZHsod/42063YtS2H3CePZ5BZ9Fl7Q9d8sSrN
         kqYE9gSPwKWjD0CbaYQ8X4AQGl/VFz4PytrPcRc+t2gUWvw7xtSWWfZCgIjxJASix/KV
         ergEKfdXZ/wjPQxP8Qz4EpK77exURT7conEv++CBPFoh2njFHHS9TDs+g1Lco7DfZzeC
         MIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DPWhA4Bdk7YoqJ/5PFItADTPFceUHiMZjzWCHLbK46s=;
        b=l7a5O6LJJxraPg9X+RQTBj1p9k2kdAUv6LJlybXT9o2WNxYrvr42AShvukqicItqNt
         8Kdf1jnyIpq/KdgCr+0PRgN6oecLQKPTkG9daIk0vsH5j3VdisfWbokllw/USOVjFtVk
         mvXiIFSvdR5il1FpXr/xU9haj8/2q3sD7xsG6r/ZtkKC2g+AwBmR/MWDNX//ZvU86jIt
         qjCid/GXi0qKlqzKXw00ng6E+sEtqVZ1ObtLwLSs/Oae3TzbSMLEMc9hDPI1VZZ9lSWK
         qHWzpZ4vcMmNXDXrYrHkBI6SLOPSt6ALYaBjtm44HCnlf5F+bizmFFbANZslkCkaCGtA
         TYhA==
X-Gm-Message-State: AOAM531oDfrDnbB8Sz4YUDZaHBVWb4XykuAtzPWNls1Oe4fTy4311/Lv
        08482vA8wB0eyxblsKO86hA=
X-Google-Smtp-Source: ABdhPJwUC66xptPA21fwJPq6lATEyyTX7Y34lh8n0XiujVsGcZhrSQiZNaGZgHyoAh0yQex1PU/vag==
X-Received: by 2002:a17:90a:bd95:: with SMTP id z21mr1714406pjr.214.1616031189217;
        Wed, 17 Mar 2021 18:33:09 -0700 (PDT)
Received: from localhost ([103.220.76.197])
        by smtp.gmail.com with ESMTPSA id p3sm243131pgl.88.2021.03.17.18.33.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Mar 2021 18:33:08 -0700 (PDT)
Date:   Thu, 18 Mar 2021 09:33:13 +0800
From:   Yue Hu <zbestahu@gmail.com>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "huyue2@yulong.com" <huyue2@yulong.com>,
        "zbestahu@163.com" <zbestahu@163.com>
Subject: Re: [PATCH] scsi: ufs: Tidy up WB configuration code
Message-ID: <20210318093313.000073ad.zbestahu@gmail.com>
In-Reply-To: <DM6PR04MB6575F4023FAC6600288A8973FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210317114438.1900-1-zbestahu@gmail.com>
        <DM6PR04MB6575F4023FAC6600288A8973FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 Mar 2021 14:02:23 +0000
Avri Altman <Avri.Altman@wdc.com> wrote:

> > 
> > From: Yue Hu <huyue2@yulong.com>
> > 
> > There are similar code implemetentions for WB configurations in
> > ufshcd_wb_{ctrl, toggle_flush_during_h8, toggle_flush}. We can
> > extract the part to create a new helper with a flag parameter to
> > reduce code duplication.
> > 
> > Meanwhile, change ufshcd_wb_ctrl() -> ufshcd_wb_toggle() for better
> > readability.
> > 
> > And remove unnecessary log messages from ufshcd_wb_config() since
> > relevant toggle function will spew log respectively. Also change
> > ufshcd_wb_toggle_flush{__during_h8} to void type accordingly.
> > 
> > Signed-off-by: Yue Hu <huyue2@yulong.com>  
> A small nit below, otherwise - looks good to me.
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> 
> > ---
> >  drivers/scsi/ufs/ufs-sysfs.c |  2 +-
> >  drivers/scsi/ufs/ufshcd.c    | 99 +++++++++++++++++++-------------------------
> >  drivers/scsi/ufs/ufshcd.h    |  2 +-
> >  3 files changed, 44 insertions(+), 59 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> > index acc54f5..d7c3cff 100644
> > --- a/drivers/scsi/ufs/ufs-sysfs.c
> > +++ b/drivers/scsi/ufs/ufs-sysfs.c
> > @@ -246,7 +246,7 @@ static ssize_t wb_on_store(struct device *dev, struct
> > device_attribute *attr,
> >         }
> > 
> >         pm_runtime_get_sync(hba->dev);
> > -       res = ufshcd_wb_ctrl(hba, wb_enable);
> > +       res = ufshcd_wb_toggle(hba, wb_enable);
> >         pm_runtime_put_sync(hba->dev);
> >  out:
> >         up(&hba->host_sem);
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 7716175..1368f9e 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -247,8 +247,8 @@ static int ufshcd_change_power_mode(struct ufs_hba
> > *hba,
> >  static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
> >                                          struct ufs_vreg *vreg);
> >  static int ufshcd_try_to_abort_task(struct ufs_hba *hba, int tag);
> > -static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
> > -static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
> > +static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set);
> > +static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable);
> >  static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba);
> >  static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba);
> > 
> > @@ -275,20 +275,12 @@ static inline void ufshcd_disable_irq(struct ufs_hba
> > *hba)
> > 
> >  static inline void ufshcd_wb_config(struct ufs_hba *hba)
> >  {
> > -       int ret;
> > -
> >         if (!ufshcd_is_wb_allowed(hba))
> >                 return;
> > 
> > -       ret = ufshcd_wb_ctrl(hba, true);
> > -       if (ret)
> > -               dev_err(hba->dev, "%s: Enable WB failed: %d\n", __func__, ret);
> > -       else
> > -               dev_info(hba->dev, "%s: Write Booster Configured\n", __func__);
> > -       ret = ufshcd_wb_toggle_flush_during_h8(hba, true);
> > -       if (ret)
> > -               dev_err(hba->dev, "%s: En WB flush during H8: failed: %d\n",
> > -                       __func__, ret);
> > +       ufshcd_wb_toggle(hba, true);
> > +
> > +       ufshcd_wb_toggle_flush_during_h8(hba, true);
> >         if (!(hba->quirks & UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL))
> >                 ufshcd_wb_toggle_flush(hba, true);
> >  }
> > @@ -1268,7 +1260,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba,
> > bool scale_up)
> >         /* Enable Write Booster if we have scaled up else disable it */
> >         downgrade_write(&hba->clk_scaling_lock);
> >         is_writelock = false;
> > -       ufshcd_wb_ctrl(hba, scale_up);
> > +       ufshcd_wb_toggle(hba, scale_up);
> > 
> >  out_unprepare:
> >         ufshcd_clock_scaling_unprepare(hba, is_writelock);
> > @@ -5432,85 +5424,78 @@ static void
> > ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
> >                                 __func__, err);
> >  }
> > 
> > -int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable)
> > +static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn
> > idn)
> >  {
> > -       int ret;
> > +       int val;  
> Use turnery here?

Hi Avri,

Should use "enum query_opcode opcode", rt? will fix it in v2.

Thank you for reviewing the patch!

> 
> 
> >         u8 index;
> > -       enum query_opcode opcode;
> > +
> > +       if (set)
> > +               val = UPIU_QUERY_OPCODE_SET_FLAG;
> > +       else
> > +               val = UPIU_QUERY_OPCODE_CLEAR_FLAG;
> > +
> > +       index = ufshcd_wb_get_query_index(hba);
> > +       return ufshcd_query_flag_retry(hba, val, idn, index, NULL);
> > +}
> > +
> > +int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable)
> > +{
> > +       int ret;
> > 
> >         if (!ufshcd_is_wb_allowed(hba))
> >                 return 0;
> > 
> >         if (!(enable ^ hba->dev_info.wb_enabled))
> >                 return 0;
> > -       if (enable)
> > -               opcode = UPIU_QUERY_OPCODE_SET_FLAG;
> > -       else
> > -               opcode = UPIU_QUERY_OPCODE_CLEAR_FLAG;
> > 
> > -       index = ufshcd_wb_get_query_index(hba);
> > -       ret = ufshcd_query_flag_retry(hba, opcode,
> > -                                     QUERY_FLAG_IDN_WB_EN, index, NULL);
> > +       ret = __ufshcd_wb_toggle(hba, enable, QUERY_FLAG_IDN_WB_EN);
> >         if (ret) {
> > -               dev_err(hba->dev, "%s write booster %s failed %d\n",
> > +               dev_err(hba->dev, "%s Write Booster %s failed %d\n",
> >                         __func__, enable ? "enable" : "disable", ret);
> >                 return ret;
> >         }
> > 
> >         hba->dev_info.wb_enabled = enable;
> > -       dev_dbg(hba->dev, "%s write booster %s %d\n",
> > -                       __func__, enable ? "enable" : "disable", ret);
> > +       dev_info(hba->dev, "%s Write Booster %s\n",
> > +                       __func__, enable ? "enabled" : "disabled");
> > 
> >         return ret;
> >  }
> > 
> > -static int ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
> > +static void ufshcd_wb_toggle_flush_during_h8(struct ufs_hba *hba, bool set)
> >  {
> > -       int val;
> > -       u8 index;
> > -
> > -       if (set)
> > -               val =  UPIU_QUERY_OPCODE_SET_FLAG;
> > -       else
> > -               val = UPIU_QUERY_OPCODE_CLEAR_FLAG;
> > +       int ret;
> > 
> > -       index = ufshcd_wb_get_query_index(hba);
> > -       return ufshcd_query_flag_retry(hba, val,
> > -                               QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8,
> > -                               index, NULL);
> > +       ret = __ufshcd_wb_toggle(hba, set,
> > +                       QUERY_FLAG_IDN_WB_BUFF_FLUSH_DURING_HIBERN8);
> > +       if (ret) {
> > +               dev_err(hba->dev, "%s: WB-Buf Flush during H8 %s failed: %d\n",
> > +                       __func__, set ? "enable" : "disable", ret);
> > +               return;
> > +       }
> > +       dev_dbg(hba->dev, "%s WB-Buf Flush during H8 %s\n",
> > +                       __func__, set ? "enabled" : "disabled");
> >  }
> > 
> > -static inline int ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
> > +static inline void ufshcd_wb_toggle_flush(struct ufs_hba *hba, bool enable)
> >  {
> >         int ret;
> > -       u8 index;
> > -       enum query_opcode opcode;
> > 
> >         if (!ufshcd_is_wb_allowed(hba) ||
> >             hba->dev_info.wb_buf_flush_enabled == enable)
> > -               return 0;
> > -
> > -       if (enable)
> > -               opcode = UPIU_QUERY_OPCODE_SET_FLAG;
> > -       else
> > -               opcode = UPIU_QUERY_OPCODE_CLEAR_FLAG;
> > +               return;
> > 
> > -       index = ufshcd_wb_get_query_index(hba);
> > -       ret = ufshcd_query_flag_retry(hba, opcode,
> > -                                     QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, index,
> > -                                     NULL);
> > +       ret = __ufshcd_wb_toggle(hba, enable,
> > QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN);
> >         if (ret) {
> >                 dev_err(hba->dev, "%s WB-Buf Flush %s failed %d\n", __func__,
> >                         enable ? "enable" : "disable", ret);
> > -               goto out;
> > +               return;
> >         }
> > 
> >         hba->dev_info.wb_buf_flush_enabled = enable;
> > 
> > -       dev_dbg(hba->dev, "WB-Buf Flush %s\n", enable ? "enabled" : "disabled");
> > -out:
> > -       return ret;
> > -
> > +       dev_dbg(hba->dev, "%s WB-Buf Flush %s\n",
> > +                       __func__, enable ? "enabled" : "disabled");
> >  }
> > 
> >  static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 18e56c1..eddc819 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -1099,7 +1099,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba
> > *hba,
> >                              u8 *desc_buff, int *buff_len,
> >                              enum query_opcode desc_op);
> > 
> > -int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
> > +int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
> > 
> >  /* Wrapper functions for safely calling variant operations */
> >  static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
> > --
> > 1.9.1  
> 

