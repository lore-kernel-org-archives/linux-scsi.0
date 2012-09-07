From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi/ibmvscsi: add module alias for ibmvscsic
Date: Fri, 7 Sep 2012 11:16:49 -0500
Message-ID: <CALAi6FcBMthd2+2RsGbVwH4opy2TVFQo4KdT=KEsT06ZUUjtyQ@mail.gmail.com>
References: <1342630158-16510-1-git-send-email-olaf@aepfle.de>
	<1343611946.21647.23.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35959 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2IGQQw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Sep 2012 12:16:52 -0400
Received: by ieje11 with SMTP id e11so5322593iej.19
        for <linux-scsi@vger.kernel.org>; Fri, 07 Sep 2012 09:16:49 -0700 (PDT)
In-Reply-To: <1343611946.21647.23.camel@pasglop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Brian J King <bjking1@us.ibm.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, olaf@aepfle.de

On Sun, Jul 29, 2012 at 8:32 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2012-07-18 at 18:49 +0200, olaf@aepfle.de wrote:
>> From: Olaf Hering <olaf@aepfle.de>
>>
>> The driver is named ibmvscsic, at runtime it its name is advertised as
>> ibmvscsi. For this reason mkinitrd wont pickup the driver properly.
>> Reported by IBM during SLES11 beta testing:
>>
>> https://bugzilla.novell.com/show_bug.cgi?id=459933
>> LTC50724
>
> So while this would work, I do wonder however whether we could instead
> fix it by simplifying the whole thing as follow since iSeries is now
> gone and so we don't need split backends anymore:
>
> scsi/ibmvscsi: Remove backend abstraction
>
> Now that the iSeries code is gone the backend abstraction
> in this driver is no longer necessary, which allows us to
> consolidate the driver in one file.
>
> The side effect is that the module name is now ibmvscsi.ko
> which matches the driver hotplug name and fixes auto-load
> issues.
>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.

I've give this a quick test and I prefer this cleanup, it solves the
initial problem nicely.

James, please consider pulling this patch.  Thanks.

Acked-by: Robert Jennings <rcj@linux.vnet.ibm.com>
