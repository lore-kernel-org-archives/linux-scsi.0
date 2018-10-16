From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 02/11] scsi: sd_zbc: Reduce boot device
	scan and revalidate time
Date: Tue, 16 Oct 2018 00:50:21 -0400
Message-ID: <yq14ldmv6k2.fsf@oracle.com>
References: <20181012100850.23316-1-damien.lemoal@wdc.com>
	<20181012100850.23316-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181012100850.23316-3-damien.lemoal@wdc.com> (Damien Le Moal's
	message of "Fri, 12 Oct 2018 19:08:41 +0900")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org


Damien,

> Handling checks of ZBC device capacity using the max_lba field of the
> REPORT ZONES command reply for disks with rc_basis == 0 can be done
> using the same report zones command reply used to check the "same"
> field.
>
> Avoid executing a report zones command solely to check the disk capacity
> by merging sd_zbc_check_capacity() into sd_zbc_check_zone_size() and
> renaming that function to sd_zbc_check_zones(). This removes a costly
> execution of a full report zones command and so reduces device scan
> duration at boot time as well as the duration of disk revalidate calls.
>
> Furthermore, setting the partial report bit in the REPORT ZONES command
> cdb can significantly reduce this command execution time as the device
> does not have to count and report the total number of zones that could
> be reported assuming a large enough reply buffer. A non-partial zone
> report is necessary only for the first execution of report zones used to
> check the same field value (to ensure that this value applies to all
> zones of the disk). All other calls to sd_zbc_report_zones() can use a
> partial report to reduce execution time.
>
> Using a 14 TB ZBC disk, these simple changes reduce device scan time at
> boot from about 3.5s down to about 900ms. Disk revalidate times are also
> reduced from about 450ms down to 230ms.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
