From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 2/2] dm mpath: attach scsi_dh during table resume
Date: Thu, 25 Apr 2013 16:27:35 +0100
Message-ID: <51794B67.2000903@redhat.com>
References: <20130404131631.GA10208@redhat.com> <1365457816-31475-1-git-send-email-snitzer@redhat.com> <1365457816-31475-2-git-send-email-snitzer@redhat.com> <20130422223355.GA4803@redhat.com> <Pine.LNX.4.64.1304250938480.8307@file.rdu.redhat.com> <20130425141707.GA1947@redhat.com> <Pine.LNX.4.64.1304251037320.18633@file.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755022Ab3DYP2A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Apr 2013 11:28:00 -0400
In-Reply-To: <Pine.LNX.4.64.1304251037320.18633@file.rdu.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, hare@suse.de

On 04/25/2013 03:50 PM, Mikulas Patocka wrote:
> On Thu, 25 Apr 2013, Mike Snitzer wrote:
>> The handler that is automatically attached _should_ be the correct
>> handler.  We now have the .match() hook for scsi_dh and it has made for
>> reliable scsi_dh attachment of the correct handler.
>
> The EMC devices work with both ALUA and EMC handlers - so there is no one
> "correct" handler, the correct handler is the one that the user specified
> in multipath configuration.

I think it's more absolute than that; if a Clariion array is in failover 
mode 4 (ALUA) then it's incorrect to use scsi_dh_emc and vice-versa.

The user can configure this in multipath.conf but it does not make it 
correct. The correct handler is the one that matches the configured 
failover mode of the array.

The ALUA handler scsi_device_tgps() in its match function but since the 
scsi_dh_emc match function only looks at the vendor/product it's 
impossible for it to make the correct decision.

The array can tell us what mode it's running in - teaching scsi_dh_emc 
to do this would seem to be an improvement.

Regards,
Bryn.

