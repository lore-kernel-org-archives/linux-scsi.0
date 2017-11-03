From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V3] scsi: storvsc: Allow only one remove lun work item to
 be issued per lun
Date: Fri, 03 Nov 2017 12:28:30 -0400
Message-ID: <yq1y3nn5ntd.fsf@oracle.com>
References: <1509454326-11118-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1509454326-11118-1-git-send-email-cavery@redhat.com> (Cathy
 Avery's message of "Tue, 31 Oct 2017 08:52:06 -0400")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Cathy Avery <cavery@redhat.com>
Cc: sthemmin@microsoft.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, hch@infradead.org, devel@linuxdriverproject.org, tj@kernel.org, jejb@linux.vnet.ibm.com, dan.carpenter@oracle.com
List-Id: linux-scsi@vger.kernel.org


Cathy,

> When running multipath on a VM if all available paths go down the
> driver can schedule large amounts of storvsc_remove_lun work items to
> the same lun. In response to the failing paths typically storvsc
> responds by taking host->scan_mutex and issuing a TUR per lun. If
> there has been heavy IO to the failed device all the failed IOs are
> returned from the host. A remove lun work item is issued per failed
> IO. If the outstanding TURs have not been completed in a timely manner
> the scan_mutex is never released or released too late. Consequently
> the many remove lun work items are not completed as scsi_remove_device
> also tries to take host->scan_mutex.  This results in dragging the VM
> down and sometimes completely.
>
> This patch only allows one remove lun to be issued to a particular lun
> while it is an instantiated member of the scsi stack.

Applied to 4.15/scsi-queue.

Next time the change log needs to go after a "---" delimiter.

Thank you!

> Changes since v1:
> Use single threaded workqueue to serialize work in
> storvsc_handle_error [Christoph Hellwig]
>
> Changes since v2:
> Replaced create_singlethread_workqueue with
> alloc_ordered_workqueue [Christoph Hellwig]
>
> Added reviewed by's.

-- 
Martin K. Petersen	Oracle Linux Engineering
