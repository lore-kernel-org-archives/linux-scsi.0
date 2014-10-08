From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
Date: Wed, 08 Oct 2014 08:58:10 +0300
Message-ID: <5434D272.8090007@dev.mellanox.co.il>
References: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61907 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaJHF6O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2014 01:58:14 -0400
Received: by mail-wg0-f52.google.com with SMTP id a1so10773176wgh.23
        for <linux-scsi@vger.kernel.org>; Tue, 07 Oct 2014 22:58:12 -0700 (PDT)
In-Reply-To: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jay Kallickal <jayamohank@gmail.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, linux-rdma@vger.kernel.org
Cc: Minh Tran <minhduc.tran@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

On 10/8/2014 3:41 AM, Jay Kallickal wrote:
> From: Jayamohan Kallickal <jayamohank@gmail.com>
>
> 	This patch allows the underlying hardware to choose
> values other than  hard coded max values for cqe and send_wr
> while preventing them from exceeding max supported values.

Hi Minh and Jayamohan,

So I agree that we would want to take device capabilities into account
here, but we need to be able to adjust scsi_cmds_max (can_queue) in case
the max wqe supported is lower than scsi_cmds_max * num_posts_per_cmd.

So generally I agree with this approach, but we need to take care of
stuff later when the session is created.

One more thing, this is not rebased on the latest iser patches please
send v1 on top of: http://marc.info/?l=linux-rdma&m=141216135013146&w=2

P.S.
What device did you test with (that supports less than iSER needs)?

Thanks!
Sagi.

>
> Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>   drivers/infiniband/ulp/iser/iser_verbs.c | 18 ++++++++++++++----
>   1 file changed, 14 insertions(+), 4 deletions(-)
>
