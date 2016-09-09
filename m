From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 3/3] scsi/ncr5380: Improve interrupt latency during PIO tranfers
Date: Fri, 09 Sep 2016 07:28:54 -0400
Message-ID: <yq1r38tfh1l.fsf@sermon.lab.mkp.net>
References: <20160827022959.303563262@telegraphics.com.au>
        <20160831044453.413698369@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20160831044453.413698369@telegraphics.com.au> (Finn Thain's
        message of "Wed, 31 Aug 2016 14:44:56 +1000")
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Finn" == Finn Thain <fthain@telegraphics.com.au> writes:

Finn> Large PIO transfers are broken up into chunks to try to avoid
Finn> disabling local IRQs for long periods. But IRQs are still disabled
Finn> for too long and this causes SCC FIFO overruns during serial port
Finn> transfers.

Finn> This patch reduces the PIO chunk size to reduce interrupt latency
Finn> to something on the order of milliseconds, at the expense of
Finn> additional CPU overhead from extra iterations of the
Finn> NCR5380_main() loop.

Finn> That CPU overhead is a problem for slow machines (e.g. mac_scsi on
Finn> 25 MHz
Finn> 68030) but these machines generally use PDMA not PIO. This patch
Finn>        doesn't
Finn> make the overhead any worse on my Mac LC III (because it only gets
Finn> about 510 accesses per ms).

Finn> This patch decreases disk performance by a fraction of one percent
Finn> for dmx3191d on my 333 MHz PowerPC 750. Other affected hardware
Finn> (such as g_NCR5380 on x86) was not tested but 5380 ISA cards
Finn> generally use PDMA and not PIO.

Geert?

-- 
Martin K. Petersen	Oracle Linux Engineering
