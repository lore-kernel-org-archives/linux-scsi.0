From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [SCSI] csiostor: Chelsio FCoE offload driver
Date: Wed, 16 Apr 2014 18:37:16 +0300
Message-ID: <20140416153716.GH4963@mwanda>
References: <20140416153324.GA16325@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24787 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756319AbaDPPhX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Apr 2014 11:37:23 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s3GFbMcP008923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Apr 2014 15:37:23 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s3GFbL6d024282
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Apr 2014 15:37:22 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s3GFbLDe023619
	for <linux-scsi@vger.kernel.org>; Wed, 16 Apr 2014 15:37:21 GMT
Content-Disposition: inline
In-Reply-To: <20140416153324.GA16325@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Naresh's email is dead.

regards,
dan carpenter

On Wed, Apr 16, 2014 at 06:33:24PM +0300, Dan Carpenter wrote:
> Hello Naresh Kumar Inna,
> 
> The patch a3667aaed569: "[SCSI] csiostor: Chelsio FCoE offload
> driver" from Nov 15, 2012, leads to the following static checker
> warning:
> 
> 	drivers/scsi/csiostor/csio_mb.c:1534 csio_mb_isr_handler()
> 	warn: was 'sizeof(*mbp)' intended?
> 
> drivers/scsi/csiostor/csio_mb.c
>   1451  int
>   1452  csio_mb_isr_handler(struct csio_hw *hw)
>   1453  {
>   1454          struct csio_mbm         *mbm = &hw->mbm;
>                                          ^^^
> This struct is fairly large.
> 
>   1455          struct csio_mb          *mbp =  mbm->mcurrent;
>   1456          __be64                  *cmd;
>   1457          uint32_t                ctl, cim_cause, pl_cause;
>   1458          int                     i;
>   1459          uint32_t                ctl_reg = PF_REG(hw->pfn, CIM_PF_MAILBOX_CTRL);
> 
> [ snip ]
> 
>   1530                  /*
>   1531                   * Enqueue event to EventQ. Events processing happens
>   1532                   * in Event worker thread context
>   1533                   */
>   1534                  if (csio_enqueue_evt(hw, CSIO_EVT_MBX, mbp, sizeof(mbp)))
>                                                                     ^^^^^^^^^^
> This is equivalent to sizeof(long) when sizeof(*mbp) was probably
> intended.
> 
>   1535                          CSIO_INC_STATS(hw, n_evt_drop);
>   1536  
> 
> regards,
> dan carpenter
