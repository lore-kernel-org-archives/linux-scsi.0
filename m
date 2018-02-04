From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v4 01/10] ufs: sysfs: attribute group for existing sysfs
 entries.
Date: Sun, 4 Feb 2018 13:33:43 +0100
Message-ID: <20180204123343.GA940@kroah.com>
References: <1517501746-19075-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1517501746-19075-2-git-send-email-stanislav.nijnikov@wdc.com>
 <20180201165923.GA12838@kroah.com>
 <DM2PR0401MB097509D74E03449B0FA616249AFF0@DM2PR0401MB0975.namprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36712 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750802AbeBDMeD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Feb 2018 07:34:03 -0500
Content-Disposition: inline
In-Reply-To: <DM2PR0401MB097509D74E03449B0FA616249AFF0@DM2PR0401MB0975.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stanislav Nijnikov <Stanislav.Nijnikov@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jaegeuk@kernel.org" <jaegeuk@kernel.org>, Alex Lemberg <Alex.Lemberg@wdc.com>

On Sun, Feb 04, 2018 at 12:29:06PM +0000, Stanislav Nijnikov wrote:
> > > +	curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> > > +			     "\nAll available Runtime PM levels info:\n");
> > > +	for (lvl = UFS_PM_LVL_0; lvl < UFS_PM_LVL_MAX; lvl++)
> > > +		curr_len += snprintf((buf + curr_len), (PAGE_SIZE - curr_len),
> > > +				     "\tRuntime PM level [%d] => dev_state
> > [%s] link_state [%s]\n",
> > > +				    lvl,
> > > +				    ufschd_ufs_dev_pwr_mode_to_string(
> > > +					ufs_pm_lvl_states[lvl].dev_state),
> > > +				    ufschd_uic_link_state_to_string(
> > > +					ufs_pm_lvl_states[lvl].link_state));
> > > +
> > 
> > sysfs if "one value per file", not "random text that someone has to parse per
> > file" please.
> > 
> > Huge hint, if you ever care about checking the size of the sysfs buffer you are
> > writing into, you are doing something really really wrong.
> > 
> Hi Greg
> It's the existing code, added by:
> commit 09690d5a6ae1b7e4cb5ac429c311b99d09352c12
> Author: subhashj@codeaurora.org <subhashj@codeaurora.org>
> Date:   Thu Dec 22 18:41:00 2016 -0800
> 
>     scsi: ufs: provide sysfs attribute to select the PM level
>     
>     This patch provides the sysfs attribute to choose the power management
>     level for UFS runtime and system suspend.
>     
>     Reviewed-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
>     Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> I just moved it to an another file and changed the sysfs entries creation by
> Jaegeuk Kim' request. At the moment the entry shows the PM level, the device
> state, the link state and all possible PM levels. Do you want me to change it?

Ah, you are just moving this code around.  Ok, that's fine for this
patch, but please fix it up as part of this patch series because this
isn't an acceptable sysfs file at all.  If it were documented that would
be a lot more obvious as to just how wrong it was :(

And, as it wasn't documented, you can change it as it's obvious no one
used it :)

thanks,

greg k-h
