From: "Surekha.PC" <surekhap@cisco.com>
Subject: RE: [PATCH][RFC] iSCSI transport class
Date: Tue, 30 Mar 2004 19:51:52 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAA2gVe7Un3YUak/sHlj1pNxAEAAAAA@cisco.com>
References: <4064979E.3020208@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:6919 "EHLO
	sj-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S263668AbUC3OV6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2004 09:21:58 -0500
In-Reply-To: <4064979E.3020208@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org
To: 'Mike Christie' <michaelc@cs.wisc.edu>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, linux-iscsi-devel@lists.sourceforge.net


 Hi Mike,

 I have reviewed your changes for iSCSI transport class. The changes look
fine.
 I have few suggestions on further improvements. The attributes can be
organised
 under iSCSI transport class in the following structure.

# ls /sys/class/iscsi_transport/*

  /* iSCSI host specific attributes */
  |-- shutdown
  |-- host_id
  |-- ....

  /* iSCSI target specific attributes */
  |-- 1:0:1/
           |-- target_addr
           |-- target_name
           |-- target_port
           |-- ....

  /* lun specific attributes */
  |-- 1:0:1:0/
             |-- device -> ../../../devices/platform/iscsi/1:0:0:0
             |-- driver -> ../../../bus/scsi/drivers/sd
             |-- lun_status
             |-- ....

 This way the relevant attributes can be used from respective paths.
  
Thanks,
surekha

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Mike Christie
> Sent: Saturday, March 27, 2004 2:21 AM
> To: SCSI Mailing List; linux-iscsi-devel@lists.sourceforge.net
> Subject: [PATCH][RFC] iSCSI transport class
> 
> 
> Attached is the begining of an iSCSI transport class. 
> Currently, the Cisco driver has some sysfs issues, so the 
> patch in the next mail will convert their print_info 
> attribute to use this class instead.
> 
> This patch was built against 2.6.5-rc2. And, here is a tree. 
> Not much yet, so please send comments. Maybe it should be per 
> session instead of per device?
> 
> [mc@minna 1:0:0:0]$ pwd
> /sys/class/iscsi_transport/1:0:0:0
> [mc@minna 1:0:0:0]$ tree
> .
> |-- device -> ../../../devices/platform/iscsi/1:0:0:0
> |-- driver -> ../../../bus/scsi/drivers/sd
> |-- target_addr
> |-- target_name
> `-- target_port
> 
> Mike Christie
> 

