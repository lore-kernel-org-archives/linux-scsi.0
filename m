From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Remove unused variable
Date: Mon, 21 Feb 2011 01:44:33 -0800
Message-ID: <1298281473.26616.69.camel@haakon2.linux-iscsi.org>
References: <AANLkTi=dHh9Ombj=ZgA4AnPUyD3qo9kcr8z7UbXce-Or@mail.gmail.com>
	 <1297725129.29207.34.camel@haakon2.linux-iscsi.org>
	 <AANLkTikxd4QeKjFhBAWbH6fqo2ef0xZQLQEgtB3Mj0rk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42725 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1BUKBW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Feb 2011 05:01:22 -0500
In-Reply-To: <AANLkTikxd4QeKjFhBAWbH6fqo2ef0xZQLQEgtB3Mj0rk@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2011-02-15 at 21:02 +0100, Fubo Chen wrote:
> On Tue, Feb 15, 2011 at 12:12 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > The usage of ref_cmd here will be used in for-39 code, so this should be
> > kept in place for now..
> 
> I'm curious to see it.
> 
> Does the patch below make sense ? It removes an unused argument from
> transport_get_lun_for_cmd().
> 

Hi Fubo,

Catching up on some items from last week..  This patch to remove the now
unnecessary usage of a *cdb pointer for transport_get_lun_for_cmd()
looks fine to me.  Commited as d658eb82af into the new
lio-core-2.6.git/lio-4.1 as a for-39 item.

Thanks!

--nab

> diff --git a/drivers/target/target_core_device.c
> b/drivers/target/target_core_device.c
> index 5da051a..53f31fd 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -56,7 +56,6 @@ static void se_dev_stop(struct se_device *dev);
> 
>  int transport_get_lun_for_cmd(
>  	struct se_cmd *se_cmd,
> -	unsigned char *cdb,
>  	u32 unpacked_lun)
>  {
>  	struct se_dev_entry *deve;
> diff --git a/include/target/target_core_device.h
> b/include/target/target_core_device.h
> index 52b18a5..d9745bf 100644
> --- a/include/target/target_core_device.h
> +++ b/include/target/target_core_device.h
> @@ -1,7 +1,7 @@
>  #ifndef TARGET_CORE_DEVICE_H
>  #define TARGET_CORE_DEVICE_H
> 
> -extern int transport_get_lun_for_cmd(struct se_cmd *, unsigned char *, u32);
> +extern int transport_get_lun_for_cmd(struct se_cmd *, u32);
>  extern int transport_get_lun_for_tmr(struct se_cmd *, u32);
>  extern struct se_dev_entry *core_get_se_deve_from_rtpi(
>  					struct se_node_acl *, u16);

