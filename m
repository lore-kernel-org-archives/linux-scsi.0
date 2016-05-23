From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [regression] uas no longer queues commands since v4.5.2
Date: Mon, 23 May 2016 13:48:16 +0200
Message-ID: <b2eca29b-a954-f35b-7880-a99a2d6ddab8@redhat.com>
References: <CAGnHSEnR8n3-zxn767DEQv7eoDbA0cc3d_7xo8OZmO+g4jth+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353AbcEWLsV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2016 07:48:21 -0400
In-Reply-To: <CAGnHSEnR8n3-zxn767DEQv7eoDbA0cc3d_7xo8OZmO+g4jth+w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>, linux-usb@vger.kernel.org, gregkh@linuxfoundation.org
Cc: linux-scsi@vger.kernel.org

Hi,

On 22-05-16 12:39, Tom Yan wrote:
> With commit 198de51dbc3454d95b015ca0a055b673f85f01bb, uas no longer
> set `queue_depth` with scsi_change_queue_depth(), so now `queue_depth`
> of UAS drives are 1. Even though `can_queue` is set to
> `devinfo->qdepth - 2`, but apparently that does not help, since I can
> see performance impact.
>
> Suppose limiting `can_queue` is the right way to fix this bug
> (https://bugzilla.redhat.com/show_bug.cgi?id=1315013), do we really
> need to eliminate scsi_change_queue_depth() at the same time though?

No, I thought it was no longer needed, assuming the slave would
inherit the host's value, but I was mistaken, the slave will default
to a queue_depth of 1 if not specified.

I'll send out a patch fixing this right away.

Regards,

Hans
