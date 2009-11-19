From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/4] be2iscsi: code reorganizing and minor changes
Date: Thu, 19 Nov 2009 16:38:11 -0600
Message-ID: <4B05C8D3.6040404@cs.wisc.edu>
References: <20091119222324.d192ab2d@mailhost.serverengines.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030509000904080906000501"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56801 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757266AbZKSWiP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2009 17:38:15 -0500
In-Reply-To: <20091119222324.d192ab2d@mailhost.serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

This is a multi-part message in MIME format.
--------------030509000904080906000501
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jayamohan Kalickal wrote:
> No, I haven't tested it with libiscsi fixups. 
> 
> The whole packet including header is passed upwards ,so, I don't see a reason it won't work.
> 
> Will I get your changes in the latest git tree?

The kernel code is in scsi-misc (it is also in linux-2.6-iscsi but that 
might not have your newer be2iscsi changes). For the kernel stuff you 
will need the attached patch for be2iscsi.

For userspace support get the offload branch of the open-iscsi.git tree.



> 
> -Jay
> 
>   _____  
> From: Mike Christie [mailto:michaelc@cs.wisc.edu]
> To: Jayamohan Kalickal [mailto:jayamohank@serverengines.com]
> Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de
> Sent: Thu, 19 Nov 2009 13:55:13 -0800
> Subject: Re: [PATCH 4/4] be2iscsi: code reorganizing and minor changes
> 
> Jayamohan Kallickal wrote:
>>              This patch does a couple of very small, mostly
>>     single line changes which I feel will be an overkill to put in
>>     individual patches
>>
>>  1) moved pci_set_drvdata to inside beiscsi_hba_alloc
>>  2) Enabled handling of  TEXT Response
>>  3) Added opcode for ISCSI_OP_LOGOUT_RSP, ISCSI_OP_SCSI_TMFUNC_RSP,
>>  4) Ask for ack based completion for NOOPOUT and TTT != RESERVERD
>>
> 
> I think in the future you still might want to separate these.
> 
> 
>> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
>> index ac76b14..109482f 100644
>> --- a/drivers/scsi/be2iscsi/be_main.c
>> +++ b/drivers/scsi/be2iscsi/be_main.c
> 
> 
>> @@ -564,6 +565,8 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
>>  		login_hdr = (struct iscsi_hdr *)ppdu;
>>  		login_hdr->itt = io_task->libiscsi_itt;
>>  		break;
>> +	case ISCSI_OP_TEXT_RSP:
>> +		break;
> 
> 
> Is this the only thing needed for TEXT pdu handling? Did you test with 
> my userspace changes and the libiscsi fixups?
> 
> ___________________________________________________________________________________
> This message, together with any attachment(s), contains confidential and proprietary information of
> ServerEngines Corporation and is intended only for the designated recipient(s) named above. Any unauthorized
> review, printing, retention, copying, disclosure or distribution is strictly prohibited.  If you are not the
> intended recipient of this message, please immediately advise the sender by reply email message and
> delete all copies of this message and any attachment(s). Thank you.
> 


--------------030509000904080906000501
Content-Type: text/x-patch;
 name="set-text-bit.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="set-text-bit.patch"

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d1e7e93..aebaf25 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3293,7 +3293,7 @@ disable_pci:
 struct iscsi_transport beiscsi_iscsi_transport = {
 	.owner = THIS_MODULE,
 	.name = DRV_NAME,
-	.caps = CAP_RECOVERY_L0 | CAP_HDRDGST |
+	.caps = CAP_RECOVERY_L0 | CAP_HDRDGST | CAP_TEXT_NEGO |
 		CAP_MULTI_R2T | CAP_DATADGST | CAP_DATA_PATH_OFFLOAD,
 	.param_mask = ISCSI_MAX_RECV_DLENGTH |
 		ISCSI_MAX_XMIT_DLENGTH |

--------------030509000904080906000501--
