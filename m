From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 2/2] TARGET/sbc,loopback: Adjust command data length in
 case pi exists on the wire
Date: Thu, 05 Jun 2014 20:22:15 +0300
Message-ID: <5390A747.5020506@dev.mellanox.co.il>
References: <1401639581-20111-1-git-send-email-sagig@mellanox.com>	<1401639581-20111-3-git-send-email-sagig@mellanox.com> <yq1fvjn9rqs.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45868 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaFERWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 13:22:21 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so10056005wib.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Jun 2014 10:22:19 -0700 (PDT)
In-Reply-To: <yq1fvjn9rqs.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>
Cc: nab@linux-iscsi.org, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, oren@mellanox.com

On 6/2/2014 7:54 PM, Martin K. Petersen wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:
> Sagi,
>
> Sagi> In various areas of the code, it is assumed that
> Sagi> se_cmd-> data_length describes pure data. In case
> Sagi> that protection information exists over the wire (protect bits is
> Sagi> are on) the target core decrease the protection length from the
> Sagi> data length (instead of each transport peeking in the cdb).
>
> I completely agree with the notion of including PI in the transport byte
> count.
>
> Why do you open code the transfer length adjustment below?

Can't say I have a good reason for that.
I'll move this logic to scsi_cmnd.h.

>
> +			/**
> +			 * Adjust data_length to include
> +			 * protection information
> +			 **/
> +			switch (sc->device->sector_size) {
> +			case 512:
> +				data_len += (data_len >> 9) * 8;
> +				break;
> +			case 1024:
> +				data_len += (data_len >> 10) * 8;
> +				break;
> +			case 2048:
> +				data_len += (data_len >> 11) * 8;
> +				break;
> +			case 4096:
> +				data_len += (data_len >> 12) * 8;
> +				break;
> +			default:
> +				data_len +=
> +				(data_len >> ilog2(sc->device->sector_size)) * 8;
> +			}
>

