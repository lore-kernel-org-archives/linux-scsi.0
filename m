From: Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH]: aic94xx: fix uninitialized variable warning
Date: Mon, 07 Jun 2010 14:52:44 -0400
Message-ID: <4C0D3FFC.2030204@redhat.com>
References: <20100527182056.24051.65113.sendpatchset@prarit.bos.redhat.com> <201005282118.08243.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139Ab0FGS67 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jun 2010 14:58:59 -0400
In-Reply-To: <201005282118.08243.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>


> 
>> diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c
>> b/drivers/scsi/aic94xx/aic94xx_sds.c index edb43fd..2f1751a 100644
>> --- a/drivers/scsi/aic94xx/aic94xx_sds.c
>> +++ b/drivers/scsi/aic94xx/aic94xx_sds.c
>> @@ -982,7 +982,7 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct
>> *asd_ha, struct asd_flash_dir *flash_dir)
>>  {
>>  	int err, i;
>> -	u32 offs, size;
>> +	u32 uninitialized_var(offs), size;
>>  	struct asd_ll_el *el;
>>  	struct asd_ctrla_phy_settings *ps;
>>  	struct asd_ctrla_phy_settings dflt_ps;
> 
> I would vote for putting the declarations if different lines if one of them 
> gets initialized or otherwise treated specially as it is otherwise hardly 
> readable.
> 

Thanks Eike,

New patch.



Fixes make -j24 CONFIG_DEBUG_SECTION_MISMATCH=y warning:

drivers/scsi/aic94xx/aic94xx_sds.c: In function "asd_process_ctrl_a_user":
drivers/scsi/aic94xx/aic94xx_sds.c:984: error: "offs" may be used uninitialized in this function

Fix an uninitialized variable warning.  A return value is checked elsewhere in
the function so this is safe to do.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic94xx_sds.c
index edb43fd..5a7978c 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -982,7 +982,8 @@ static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 				   struct asd_flash_dir *flash_dir)
 {
 	int err, i;
-	u32 offs, size;
+	u32 uninitialized_var(offs);
+	u32 size;
 	struct asd_ll_el *el;
 	struct asd_ctrla_phy_settings *ps;
 	struct asd_ctrla_phy_settings dflt_ps;
