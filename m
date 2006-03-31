From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH 1/3] Try LUN 1 and use bflags
Date: Fri, 31 Mar 2006 08:39:52 -0800
Message-ID: <20060331163952.GA22277@us.ibm.com>
References: <20060329201020.GG7919@tpkurt.suse.de> <20060329201147.GH7919@tpkurt.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:20099 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751418AbWCaQj4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Mar 2006 11:39:56 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k2VGduRq025104
	for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2006 11:39:56 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2VGagku221288
	for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2006 09:36:42 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k2VGdtn3006597
	for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2006 09:39:55 -0700
Content-Disposition: inline
In-Reply-To: <20060329201147.GH7919@tpkurt.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Wed, Mar 29, 2006 at 10:11:47PM +0200, Kurt Garloff wrote:
> @@ -945,11 +945,13 @@ static void scsi_sequential_lun_scan(str
>  		sparse_lun = 0;
>  
>  	/*
> -	 * If not sparse lun and no device attached at LUN 0 do not scan
> -	 * any further.
> -	 */
> +	 * If LUN0 did respond, but did not have an attachable LUN (PQ=3),
> +	 * we do NOT abort the sequential scan yet, let's try one more
> +	 * LUN and only abort the scan if we don't find anything there.
> +	 * 
>  	if (!sparse_lun && (lun0_res != SCSI_SCAN_LUN_PRESENT))
>  		return;
> +	 */

Just delete all that, and get rid of lun0_res.

-- Patrick Mansfield
