From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [SCSI] be2iscsi: adding functionality to change network settings
 using iscsiadm
Date: Thu, 04 Sep 2014 22:09:55 -0500
Message-ID: <54092983.70604@cs.wisc.edu>
References: <20140904102734.GA21504@mwanda>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040507080908010509060503"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42729 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbaIEDKH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Sep 2014 23:10:07 -0400
In-Reply-To: <20140904102734.GA21504@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, Kees Cook <keescook@chromium.org>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

This is a multi-part message in MIME format.
--------------040507080908010509060503
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/04/2014 05:27 AM, Dan Carpenter wrote:
> Hello Mike Christie,
> 
> The patch 0e43895ec1f4: "[SCSI] be2iscsi: adding functionality to
> change network settings using iscsiadm" from Apr 3, 2012, leads to
> the following static checker warning:
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

Jay, I made the attached patch to fix these issues plus one more I
found. I am still waiting on getting systems at work. Could you have
your people test it?


--------------040507080908010509060503
Content-Type: text/x-patch;
 name="be2iscsi-check-ip-buf-size.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="be2iscsi-check-ip-buf-size.patch"

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 8478506..681d4e8 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -943,17 +943,20 @@ mgmt_static_ip_modify(struct beiscsi_hba *phba,
 
 	if (ip_action == IP_ACTION_ADD) {
 		memcpy(req->ip_params.ip_record.ip_addr.addr, ip_param->value,
-		       ip_param->len);
+		       sizeof(req->ip_params.ip_record.ip_addr.addr));
 
 		if (subnet_param)
 			memcpy(req->ip_params.ip_record.ip_addr.subnet_mask,
-			       subnet_param->value, subnet_param->len);
+			       subnet_param->value,
+			       sizeof(req->ip_params.ip_record.ip_addr.subnet_mask));
 	} else {
 		memcpy(req->ip_params.ip_record.ip_addr.addr,
-		       if_info->ip_addr.addr, ip_param->len);
+		       if_info->ip_addr.addr,
+		       sizeof(req->ip_params.ip_record.ip_addr.addr));
 
 		memcpy(req->ip_params.ip_record.ip_addr.subnet_mask,
-		       if_info->ip_addr.subnet_mask, ip_param->len);
+		       if_info->ip_addr.subnet_mask,
+		       sizeof(req->ip_params.ip_record.ip_addr.subnet_mask));
 	}
 
 	rc = mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
@@ -981,7 +984,7 @@ static int mgmt_modify_gateway(struct beiscsi_hba *phba, uint8_t *gt_addr,
 	req->action = gtway_action;
 	req->ip_addr.ip_type = BE2_IPV4;
 
-	memcpy(req->ip_addr.addr, gt_addr, param_len);
+	memcpy(req->ip_addr.addr, gt_addr, sizeof(req->ip_addr.addr));
 
 	return mgmt_exec_nonemb_cmd(phba, &nonemb_cmd, NULL, 0);
 }

--------------040507080908010509060503--
