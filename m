From: Cathy Avery <cavery@redhat.com>
Subject: Re: [PATCH] scsi: storvsc: Allow only one remove lun work item to be
 issued per lun
Date: Mon, 17 Apr 2017 15:44:22 -0400
Message-ID: <58F51B16.1070202@redhat.com>
References: <1492263790-11378-1-git-send-email-cavery@redhat.com>
 <20170415140647.GA12851@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170415140647.GA12851@infradead.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: sthemmin@microsoft.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, jejb@linux.vnet.ibm.com
List-Id: linux-scsi@vger.kernel.org

On 04/15/2017 10:06 AM, Christoph Hellwig wrote:
> Just add a singlethreaded workqueue for storvsc_handle_error and you'll
> get serialization for all error handling for free.

The problem I am seeing is that many work items can be queued up for the 
same lun before it goes away. The single threaded queue would have to allow
for only a queue of one and no more. Either that or each work item for a 
particular lun must have the same memory address so it gets
rejected if it you try to queue a remove to the same lun twice.

Maybe I am not understanding your suggestion correctly.

Thanks,

Cathy
