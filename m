From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fixes compile errors in cpqfcTS driver
Date: Tue, 22 Apr 2003 07:44:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030422074414.A26090@infradead.org>
References: <3EA48555.8020600@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from carisma.slowglass.com ([195.224.96.167]:34574 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262563AbTDVGcN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 02:32:13 -0400
Content-Disposition: inline
In-Reply-To: <3EA48555.8020600@us.ibm.com>; from mikenc@us.ibm.com on Mon, Apr 21, 2003 at 04:57:09PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Apr 21, 2003 at 04:57:09PM -0700, Mike Christie wrote:
> +  Scsi_Device DumSdev;

Please use struct scsi_device in any new code.

>    int Chan, Targ, i;
>    struct info_str info;
>    CPQFCHBA *cpqfcHBA;
> @@ -963,11 +964,12 @@ int cpqfcTS_proc_info (char *buffer, cha
>  
>  #define DISPLAY_WWN_INFO
>  #ifdef DISPLAY_WWN_INFO
> +  DumCmnd.device = &DumSdev;

I don't think the onstack command/device will work anymore.
You'll have to use scsi_get_command/scsi_put_command I guess

