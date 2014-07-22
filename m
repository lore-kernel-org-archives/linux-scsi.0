From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 07/14] scsi: convert host_busy to atomic_t
Date: Tue, 22 Jul 2014 00:18:19 -0400
Message-ID: <yq1lhrmkovo.fsf@sermon.lab.mkp.net>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
	<1405678393-11497-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405678393-11497-8-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Fri, 18 Jul 2014 12:13:06 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Avoid taking the host-wide host_lock to check the per-host
Christoph> queue limit.  Instead we do an atomic_inc_return early on to
Christoph> grab our slot in the queue, and if nessecary decrement it
Christoph> after finishing all checks.

More nitpicking. In the two previous atomic conversion patches you kept
%hu for the atomic_t. Here it's %d.

+static ssize_t
+sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	return snprintf(buf, 20, "%d\n", atomic_read(&sdev->device_busy));
+}
+static DEVICE_ATTR(device_busy, S_IRUGO, sdev_show_device_busy, NULL);

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
