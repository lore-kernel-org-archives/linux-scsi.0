From: Olaf Hering <olh@suse.de>
Subject: Re: 2.6.16-rc1 crash in scsi_target_reap_work
Date: Wed, 22 Feb 2006 16:53:41 +0100
Message-ID: <20060222155341.GA4175@suse.de>
References: <20060209200529.GA8968@suse.de> <20060210101124.GA6253@suse.de> <1139580295.3084.3.camel@mulgrave.il.steeleye.com> <20060210141012.GA12147@suse.de> <20060210230140.GA26423@suse.de> <43ED1FE0.1000805@us.ibm.com> <20060210232935.GA27760@suse.de> <43FA49F9.4020309@us.ibm.com> <20060222083657.GA24802@suse.de> <43FC774B.8050301@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:11465 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S1751349AbWBVPxr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 10:53:47 -0500
Content-Disposition: inline
In-Reply-To: <43FC774B.8050301@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

 On Wed, Feb 22, Brian King wrote:
> I would guess that the -EEXIST is coming from:
> 
> create_dir

You are right:

lib/kobject.c:create_dir(57) sysfs_create_dir failed to create 'target0:255:122' 'target0:255:122' with error -17 

+++ linux-2.6.16-rc3-olh/lib/kobject.c
@@ -53,6 +53,8 @@ static int create_dir(struct kobject * k
                        if ((error = populate_dir(kobj)))
                                sysfs_remove_dir(kobj);
                }
+               else
+               printk(KERN_EMERG "%s:%s(%u) sysfs_create_dir failed to create '%s' '%s' with error %d\n",__FILE__,__FUNCTION__,__LINE__,kobj->k_name,kobj->name,error);
        }
        return error;
 }


