From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: rq_affinity doesn't seem to work?
Date: Tue, 12 Jul 2011 12:03:34 -0700
Message-ID: <D010E79907AF0D4E90B603DE907837D504CA6365D6@azsmsx504.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:7305 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab1GLTDh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2011 15:03:37 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, "Foong, Annie" <annie.foong@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>

Jens,
I'm doing some performance tuning for the Intel isci SAS controller driver, and I noticed some interesting numbers with mpstat. Looking at the numbers it seems that rq_affinity is not moving the request completion to the request submission CPU. Using fio to saturate the system with 512B I/Os, I noticed that all I/Os are bound to the CPUs (CPUs 6 and 7) that service the hard irqs. I have put in a quick hack in the driver so that it records the CPU during request construction and then I try to steer the scsi->done() calls to the request CPUs. With this simple hack, mpstat shows that the soft irq contexts are now distributed. I observed significant performance increase. The iowait% gone from 30s and 40s to low single digit approaching 0. Any ideas what could be happening with the rq_affinity 
 logic? I'm assuming rq_affinity should behave the way my hacked solution is behaving. This is running on an 8 core single CPU SandyBridge based system with hyper-threading turned off. The two MSIX interrupts on the controller are tied to CPU 6 and 7 respectively via /proc/irq/X/smp_affinity. I'm running fio with 8 SAS disks and 8 threads. 

no rq_affinity:
09:23:31 AM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
09:23:36 AM  all    9.65    0.00   41.75   23.60    0.00   24.98    0.00    0.00    0.03
09:23:36 AM    0   13.40    0.00   59.60   27.00    0.00    0.00    0.00    0.00    0.00
09:23:36 AM    1   14.00    0.00   58.80   27.20    0.00    0.00    0.00    0.00    0.00
09:23:36 AM    2   13.20    0.00   57.40   29.40    0.00    0.00    0.00    0.00    0.00
09:23:36 AM    3   12.40    0.00   57.00   30.60    0.00    0.00    0.00    0.00    0.00
09:23:36 AM    4   12.60    0.00   52.80   34.60    0.00    0.00    0.00    0.00    0.00
09:23:36 AM    5   11.62    0.00   48.30   40.08    0.00    0.00    0.00    0.00    0.00
09:23:36 AM    6    0.00    0.00    0.20    0.00    0.00   99.80    0.00    0.00    0.00
09:23:36 AM    7    0.00    0.00    0.00    0.00    0.00   99.80    0.00    0.00    0.20

with rq_affinity:
09:25:04 AM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
09:25:09 AM  all    9.50    0.00   42.32   23.19    0.00   24.99    0.00    0.00    0.00
09:25:09 AM    0   13.80    0.00   61.60   24.60    0.00    0.00    0.00    0.00    0.00
09:25:09 AM    1   13.03    0.00   60.32   26.65    0.00    0.00    0.00    0.00    0.00
09:25:09 AM    2   12.83    0.00   58.52   28.66    0.00    0.00    0.00    0.00    0.00
09:25:09 AM    3   12.20    0.00   56.60   31.20    0.00    0.00    0.00    0.00    0.00
09:25:09 AM    4   12.20    0.00   52.40   35.40    0.00    0.00    0.00    0.00    0.00
09:25:09 AM    5   11.78    0.00   49.30   38.92    0.00    0.00    0.00    0.00    0.00
09:25:09 AM    6    0.00    0.00    0.00    0.00    0.00  100.00    0.00    0.00    0.00
09:25:09 AM    7    0.00    0.00    0.00    0.00    0.00  100.00    0.00    0.00    0.00

with soft irq steering:
09:31:57 AM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest   %idle
09:32:02 AM  all   12.73    0.00   46.82    1.63    8.03   28.59    0.00    0.00    2.20
09:32:02 AM    0   16.20    0.00   55.00    3.20   10.20   15.40    0.00    0.00    0.00
09:32:02 AM    1   15.60    0.00   57.60    0.00   10.00   16.80    0.00    0.00    0.00
09:32:02 AM    2   16.03    0.00   56.91    0.20   10.62   16.23    0.00    0.00    0.00
09:32:02 AM    3   15.77    0.00   58.48    0.20   10.18   15.17    0.00    0.00    0.20
09:32:02 AM    4   16.17    0.00   56.09    0.00   10.18   17.56    0.00    0.00    0.00
09:32:02 AM    5   16.00    0.00   56.60    0.20   10.60   16.60    0.00    0.00    0.00
09:32:02 AM    6    3.41    0.00   18.64    3.81    0.80   60.52    0.00    0.00   12.83
09:32:02 AM    7    2.79    0.00   14.97    5.79    1.40   70.26    0.00    0.00    4.79
