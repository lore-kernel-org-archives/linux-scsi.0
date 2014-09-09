From: Sony John-N <Sony.John-N@Emulex.Com>
Subject: RE: [SCSI] be2iscsi: adding functionality to change network
 settings using iscsiadm
Date: Tue, 9 Sep 2014 06:26:32 +0000
Message-ID: <6b5b12f4-e46a-4467-a09f-8311377648d0@CMEXHTCAS1.ad.emulex.com>
References: <20140904102734.GA21504@mwanda> <54092983.70604@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:42249 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaIIG1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2014 02:27:04 -0400
In-Reply-To: <54092983.70604@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>



-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mike Christie
Sent: Friday, September 05, 2014 8:40 AM
To: Dan Carpenter
Cc: linux-scsi@vger.kernel.org; Kees Cook; Jayamohan Kallickal
Subject: Re: [SCSI] be2iscsi: adding functionality to change network settings using iscsiadm

On 09/04/2014 05:27 AM, Dan Carpenter wrote:
> Hello Mike Christie,
> 
> The patch 0e43895ec1f4: "[SCSI] be2iscsi: adding functionality to 
> change network settings using iscsiadm" from Apr 3, 2012, leads to the 
> following static checker warning:
> 
> 	drivers/scsi/be2iscsi/be_mgmt.c:945 mgmt_static_ip_modify()
> 	error: 'ip_param->len' from user is not capped properly
> 
> drivers/scsi/be2iscsi/be_mgmt.c
>    940          req->ip_params.ip_record.ip_addr.size_of_structure =
>    941                  sizeof(struct be_ip_addr_subnet_format);
>    942          req->ip_params.ip_record.ip_addr.ip_type = ip_type;
>    943  
>    944          if (ip_action == IP_ACTION_ADD) {
>    945                  memcpy(req->ip_params.ip_record.ip_addr.addr, ip_param->value,
>    946                         ip_param->len);
>    947  
>    948                  if (subnet_param)
>    949                          memcpy(req->ip_params.ip_record.ip_addr.subnet_mask,
>    950                                 subnet_param->value, subnet_param->len);
>                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>    951          } else {
>    952                  memcpy(req->ip_params.ip_record.ip_addr.addr,
>    953                         if_info->ip_addr.addr, ip_param->len);
>                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>    954  
>    955                  memcpy(req->ip_params.ip_record.ip_addr.subnet_mask,
>    956                         if_info->ip_addr.subnet_mask, ip_param->len);
>                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>    957          }
> 
> These memcpy()s can overflow.  It seems root only but it makes the 
> static checker complain.
> 
> One call tree is:
> 
> beiscsi_set_static_ip() <- gets iface_ip.
>   -> mgmt_set_ip()
>      -> mgmt_static_ip_modify()
> 

> Jay, I made the attached patch to fix these issues plus one more I found. I am still waiting on getting systems at work. Could you have your people test it?

Tested the patch and its working fine.
