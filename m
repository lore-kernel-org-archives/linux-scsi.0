From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm-mq and end_clone_request()
Date: Mon, 25 Jul 2016 15:00:55 -0700
Message-ID: <1490356d-2c0e-d94a-7a88-5e8bc89953ef@sandisk.com>
References: <4ed669ed-beae-76a8-b806-a284565b327a@sandisk.com>
 <20160720140815.GA19045@redhat.com> <20160720142727.GA57399@redhat.com>
 <1ca6d31d-f175-9daa-9ddd-17d653851ceb@sandisk.com>
 <20160720183321.GA20223@redhat.com>
 <84d9dc64-0c10-ed1a-7bc1-e656874853a5@sandisk.com>
 <20160725175344.GA23000@redhat.com> <20160725212325.GA23961@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0082.outbound.protection.outlook.com ([104.47.42.82]:28702
	"EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756011AbcGYWBE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2016 18:01:04 -0400
In-Reply-To: <20160725212325.GA23961@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 07/25/2016 02:23 PM, Mike Snitzer wrote:
> So I'd be curious to know if your debugging has enabled you to identify
> exactly where in the dm-mapth.c code the -EIO return is being
> established.  do_end_io() is the likely candidate -- but again the
> __must_push_back() check should prevent it and DM_ENDIO_REQUEUE should
> be returned.

Hello Mike,

Thanks for looking further into this. The pr_info() statement that I had 
added in the following code block in __multipath_map() fired what told 
me that the following code block triggered the -EIO return:

	if (!pgpath) {
		if (!must_push_back(m))
			r = -EIO;	/* Failed */
		pr_info("%s(): (a) returning %d\n", __func__, r);
		return r;
	}

 From the system log:

kernel: mpath 254:0: queue_if_no_path 1 -> 0
kernel: __multipath_map(): (a) returning -5

The code that I had added in queue_if_no_path() is as follows:

	old = test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
         [ ... ]
	pr_info("mpath %s: queue_if_no_path %d -> %d\n",
		dm_device_name(dm_table_get_md(m->ti->table)), old,
		queue_if_no_path);

Bart.
