From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi:storvsc enable reading from VPD pages on SPC-2
Date: Thu, 11 Dec 2014 22:03:44 -0500
Message-ID: <yq1vblhbmcv.fsf@sermon.lab.mkp.net>
References: <1418200705-488-1-git-send-email-longli@microsoft.com>
 <yq1h9x3cipr.fsf@sermon.lab.mkp.net>
 <BL2PR03MB1324E11F2CB6EC2652C2F85CE620@BL2PR03MB132.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <BL2PR03MB1324E11F2CB6EC2652C2F85CE620@BL2PR03MB132.namprd03.prod.outlook.com>
 (Long Li's message of "Wed, 10 Dec 2014 22:28:07 +0000")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Long Li <longli@microsoft.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Long" == Long Li <longli@microsoft.com> writes:

>> Handle the issues or handle WRITE SAME(10/16)?

Long> With this patch, the SCSI layer will be able to correctly send
Long> WRITE_SAME_16 to the Hyper-V host. It will not send WRITE_SAME_10:
Long> it has been disabled in the driver template. Do you want me to
Long> send another patch with these details?

no_write_same prevents us from attempting to use WRITE SAME(10/16) to
zero block ranges.

This is completely orthogonal to using the WRITE SAME(10/16) commands
with the UNMAP bit set to discard block ranges. The latter is controlled
by the logical block provisioning heuristics and is not affected by
no_write_same at all.

-- 
Martin K. Petersen	Oracle Linux Engineering
