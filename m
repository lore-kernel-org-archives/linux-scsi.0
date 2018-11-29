From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: storvsc: Fix a race in sub-channel creation that
 can cause panic
Date: Wed, 28 Nov 2018 21:34:03 -0500
Message-ID: <yq1a7ls1ujo.fsf@oracle.com>
References: <20181126002617.7398-1-kys@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20181126002617.7398-1-kys@linuxonhyperv.com>
 (kys@linuxonhyperv.com's message of "Mon, 26 Nov 2018 00:26:17 +0000")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: kys@linuxonhyperv.com
Cc: hch@infradead.org, Stephen Hemminger <sthemmin@microsoft.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, Haiyang Zhang <haiyangz@microsoft.com>, hare@suse.de, apw@canonical.com, devel@linuxdriverproject.org, vkuznets@redhat.com
List-Id: linux-scsi@vger.kernel.org


KY,

> From: Dexuan Cui <decui@microsoft.com>
>
> We can concurrently try to open the same sub-channel from 2 paths:
>
> path #1: vmbus_onoffer() -> vmbus_process_offer() -> handle_sc_creation().
> path #2: storvsc_probe() -> storvsc_connect_to_vsp() ->
> 	 -> storvsc_channel_init() -> handle_multichannel_storage() ->
> 	 -> vmbus_are_subchannels_present() -> handle_sc_creation().
>
> They conflict with each other, but it was not an issue before the recent
> commit ae6935ed7d42 ("vmbus: split ring buffer allocation from open"),
> because at the beginning of vmbus_open() we checked newchannel->state so
> only one path could succeed, and the other would return with -EINVAL.

Applied to 4.20/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
