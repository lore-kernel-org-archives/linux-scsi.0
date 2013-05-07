From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH v3 6/6] scsi: ufs: add dme control primitives
Date: Tue, 07 May 2013 12:45:03 +0900
Message-ID: <001101ce4ad5$42107f70$c6317e50$%jun@samsung.com>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
 <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
 <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
 <001601ce4a1c$0c485610$24d90230$%jun@samsung.com>
 <CALMYJDtuYq8BxEN7ZA5b-LLjm0ZUkuqHtSrEQDJXjKVc4r1YEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:34979 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab3EGDpF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 May 2013 23:45:05 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MME00DR2T345V10@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 07 May 2013 12:45:04 +0900 (KST)
In-reply-to: <CALMYJDtuYq8BxEN7ZA5b-LLjm0ZUkuqHtSrEQDJXjKVc4r1YEA@mail.gmail.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Santosh Y' <santoshsy@gmail.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On Tuesday, May 07, 2013, Santosh Y wrote:
> >  /**
> > + * ufshcd_dme_power_xxx - UIC command for DME_POWERON, DME_POWEROFF
> > + * @hba: per adapter instance
> > + * @on: indicate wherter power_on or power_off
> > + *
> > + * Returns 0 on success, non-zero value on failure
> > + */
> > +int ufshcd_dme_power_xxx(struct ufs_hba *hba, u8 on)
> > +{
> > +       struct uic_command uic_cmd = {0};
> > +       static const char *const action[] = {
> > +               "dme-power-off",
> > +               "dme-power-on"
> > +       };
> > +       const char *power = action[!!on];
> > +       int ret;
> > +
> > +       uic_cmd.command = on ?
> > +               UIC_CMD_DME_POWERON : UIC_CMD_DME_POWEROFF;
> > +
> > +       ret = ufshcd_send_uic_cmd(hba, &uic_cmd);
> > +       if (ret)
> > +               dev_err(hba->dev, "%s: error code %d\n", power, ret);
> > +
> > +       return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(ufshcd_dme_power_xxx);
> > +
> > +/**
> > + * ufshcd_dme_hibern8_xxx - UIC command for DME_HIBERNATE_ENTER,
> > + *                         DME_HIBERNATE_EXIT
> > + * @hba: per adapter instance
> > + * @enter: indicate wherter hibernation enter or exit
> > + *
> > + * Returns 0 on success, non-zero value on failure
> > + */
> > +int ufshcd_dme_hibern8_xxx(struct ufs_hba *hba, u8 enter)
> > +{
> > +       struct uic_command uic_cmd = {0};
> > +       static const char *const action[] = {
> > +               "dme-hibernate-exit",
> > +               "dme-hibernate-enter"
> > +       };
> > +       const char *hibern8 = action[!!enter];
> > +       u8 status;
> > +       int ret;
> > +
> > +       uic_cmd.command = enter ?
> > +               UIC_CMD_DME_HIBER_ENTER : UIC_CMD_DME_HIBER_EXIT;
> > +
> > +       mutex_lock(&hba->uic_cmd_mutex);
> > +       init_completion(&hba->hibern8_done);
> > +       ret = __ufshcd_send_uic_cmd(hba, &uic_cmd);
> > +       if (ret) {
> > +               dev_err(hba->dev, "%s: error code %d\n", hibern8, ret);
> > +               goto out;
> > +       }
> > +
> > +       if (wait_for_completion_timeout(&hba->hibern8_done,
> > +                                       msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
> > +               status = ufshcd_get_upmcrs(hba);
> > +               if (status != PWR_LOCAL) {
> > +                       dev_err(hba->dev, "%s: failed, host upmcrs:%x\n",
> > +                               hibern8, status);
> > +                       ret = status;
> > +               }
> > +       } else {
> > +               dev_err(hba->dev, "%s: timeout\n", hibern8);
> > +               ret = -ETIMEDOUT;
> > +       }
> > +out:
> > +       mutex_unlock(&hba->uic_cmd_mutex);
> > +       return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(ufshcd_dme_hibern8_xxx);
> > +
> 
> 
> power/hibernate functions can also be renamed as
> ufshcd_dme_power/hibernate_config(struct ufs_hba *hba, bool
> enable/enter) or similar instead of xxx.
Ok, I'll change the names including dme_get/set.
If you have further views, please let me know.

Thanks,
Seungwon Jeon

> 
> 
> --
> ~Santosh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

