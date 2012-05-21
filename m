From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: multipath_busy() stalls IO due to scsi_host_is_busy()
Date: Mon, 21 May 2012 17:42:57 +0200
Message-ID: <4FBA6281.3040109@itwm.fraunhofer.de>
References: <4FB39D78.9020300@itwm.fraunhofer.de> <4FB4C065.7070804@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:56088 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2EUPnD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2012 11:43:03 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id q4LFgx9h031333
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 21 May 2012 17:43:00 +0200
In-Reply-To: <4FB4C065.7070804@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: dm-devel@redhat.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/17/2012 11:09 AM, Jun'ichi Nomura wrote:
> Hi,
>
> On 05/16/12 21:28, Bernd Schubert wrote:
>> Looking through the call chain, I see the underlying problem seems to be in scsi_host_is_busy().
>>
>>> static inline int scsi_host_is_busy(struct Scsi_Host *shost)
>>> {
>>>      if ((shost->can_queue>  0&&  shost->host_busy>= shost->can_queue) ||
>>>          shost->host_blocked || shost->host_self_blocked)
>>>          return 1;
>>>
>>>      return 0;
>>> }
>
> multipath_busy() was introduced because, without that,
> a request would be prematurely sent down to SCSI,
> lose the chance of additional merges and result in
> bad performance.
>
> However, when it is target/host that is busy, I think dm should
> send the request down and let SCSI, which has better knowledge
> about the shared resource, do appropriate starvation control.
>
> Could you try the attached patch?
>
> ---
> Jun'ichi Nomura, NEC Corporation
>
> If sdev is not busy but starget and/or host is busy,
> it is better to accept a request from stacking driver.
> Otherwise, the stacking device could be starved by other device
> sharing the same target/host.
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 5dfd749..0eb4602 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1378,16 +1378,13 @@ static int scsi_lld_busy(struct request_queue *q)
>   {
>   	struct scsi_device *sdev = q->queuedata;
>   	struct Scsi_Host *shost;
> -	struct scsi_target *starget;
>
>   	if (!sdev)
>   		return 0;
>
>   	shost = sdev->host;
> -	starget = scsi_target(sdev);
>
> -	if (scsi_host_in_recovery(shost) || scsi_host_is_busy(shost) ||
> -	    scsi_target_is_busy(starget) || scsi_device_is_busy(sdev))
> +	if (scsi_host_in_recovery(shost) || scsi_device_is_busy(sdev))
>   		return 1;
>
>   	return 0;

Thanks, that works fine! I had something else in my mind for multipath, 
but if this can go into scsi we don't need the multipath patch anymore.
Are you going to officially submit it (missing signed-off)?

Thanks,
Bernd

