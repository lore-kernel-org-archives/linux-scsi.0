From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: aacraid question: is maximum_num_containers supposed to be minimum?
Date: Wed, 11 Jan 2012 09:15:20 -0500
Message-ID: <C9E26AA3-B4DE-450F-8DC6-6C706FF703A1@xyratex.com>
References: <20120111082842.GA31452@elgon.mountain>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex197.xyratex.com ([194.131.166.197]:40714 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756329Ab2AKOP3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2012 09:15:29 -0500
In-Reply-To: <20120111082842.GA31452@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

It is *both*, in part because of history, and usage.

Initially the value was the hard coded maximum number of containers (arrays) for the earlier Firmware that never reported what they were capable of, until the value became variable based on Firmware Release with a new information field. Older Firmware would report zero.

In order to stress compatibility, and reliability should the value that is returned from the Firmware report badly, if a controller had less than this value, then we would allocate at least that amount of space for containers. This is the point at which the value went from being a maximum to a minimum.

The first bus is the containers, the remaining higher buses are the physical devices. If the number of ids on a physical bus is less than the number of containers, then we up it to match the first bus to that we have symmetry. An addition check,along this vein, to make sure that the max_ids is at least the returned maximum_num_containers ...

A clarification patch replacing minimum with maximum would help, but is purely cosmetic. You are the first person to ask this question in over a decade ;->

Sincerely -- Mark Salyzyn

On Jan 11, 2012, at 3:28 AM, Dan Carpenter wrote:

> MAXIMUM_NUM_CONTAINERS is consistently used as a minimum not a maximum
> so I was wondering what was up with that?  This is ancient code that
> predates git.
> 
> drivers/scsi/aacraid/aachba.c
>   382          if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
>   383                  maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
>   384          fsa_dev_ptr = kzalloc(sizeof(*fsa_dev_ptr) * maximum_num_containers,
>   385                          GFP_KERNEL);
> 
> Btw, if maximum_num_containers were really a maximum instead of minimum
> then it should be unsigned.  That was what brought the code to my
> attention initially.
> 
> drivers/scsi/aacraid/linit.c
>  1235          if (shost->max_id < MAXIMUM_NUM_CONTAINERS)
>  1236                  shost->max_id = MAXIMUM_NUM_CONTAINERS;
>  1237          else
>  1238                  shost->this_id = shost->max_id;
> 
> regards,
> dan carpenter
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

