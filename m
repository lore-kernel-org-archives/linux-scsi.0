From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/2] Drivers: scsi: storvsc: Force discovery of LUNs that
 may have been removed.
Date: Fri, 29 Aug 2014 09:39:26 +0200
Message-ID: <54002E2E.7030301@acm.org>
References: <1408244954-27417-1-git-send-email-kys@microsoft.com> <1408244988-27456-1-git-send-email-kys@microsoft.com> <1408244988-27456-2-git-send-email-kys@microsoft.com> <20140819175431.GA4617@infradead.org> <53FDEBB9.5070704@suse.de> <53FFE87B.9040802@cs.wisc.edu> <54001B5F.9040506@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54001B5F.9040506@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@infradead.org>, "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 08/29/14 08:19, Hannes Reinecke wrote:
> On 08/29/2014 04:42 AM, Mike Christie wrote:
>> How are distros handling 0x6/0x3f/0x0e (report luns changed) when it
>> gets passed to userspace? Is everyone kicking off a new full (add and
>> delete) scan to handle this or logging it? Is the driver returning this
>> when the LUNs change?
>>
> Currently it's logged to userspace and ignored.
> Doing an automated rescan has proven to be dangerous, as it
> might disconnect any LUNs which are still in use by applications.
> Especially HA or database setups tends to become very annoyed
> when you do an automated rescan.

Has it already been considered to add newly discovered LUNs
automatically and to leave it to the user to remove stale LUNs manually
? That would be similar to what the rescan-scsi-bus.sh script does
without option -r/--remove.

Bart.
