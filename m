From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm-mq and end_clone_request()
Date: Fri, 5 Aug 2016 08:43:16 -0700
Message-ID: <6161e993-0192-4a90-caed-ab1cb843059a@sandisk.com>
References: <20160801175948.GA6685@redhat.com>
 <20160803004013.GA19956@redhat.com>
 <eb1af921-d874-1f6a-c5d0-12d3cae04256@sandisk.com>
 <20160804161047.GC6989@redhat.com>
 <4d60017e-818c-5630-549e-bf280abcf1c3@sandisk.com>
 <20160804235850.GB13132@redhat.com>
 <1649218.8261013.1470359248073.JavaMail.zimbra@redhat.com>
 <1931660518.8323360.1470397410683.JavaMail.zimbra@redhat.com>
 <2017110872.8357448.1470411545313.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:23184
	"EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161437AbcHEPn0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 11:43:26 -0400
In-Reply-To: <2017110872.8357448.1470411545313.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/05/2016 08:39 AM, Laurence Oberman wrote:
> I completely forgot I had set no_path_retry=12, so after 12 retries it will error out.
> This is likely why I had different results seemingly affected by timing.
> Mike reminded me of it this morning.
> 
> What do you have set for no_path_retry, because when I set it to queue, it blocks the paths coming back for some reason.
> I am now investigating why that is happening :).
> I see now I need to add "simultaneous all paths lost" scenarios to my QA testing, as its not a common scenario.

Hello Laurence,

I'm using the following multipath.conf file for the tests I run:

defaults {
	user_friendly_names	yes
	queue_without_daemon	no
}

blacklist {
	device {
		vendor			"ATA"
		product			".*"
	}
}

devices {
	device {
		vendor			"SCST_BIO|LIO-ORG"
		product			".*"
		features		"3 queue_if_no_path pg_init_retries 50"
		path_grouping_policy	group_by_prio
		path_selector		"queue-length 0"
		path_checker		tur
	}
}

blacklist_exceptions {
        property        ".*"
}

Bart.

