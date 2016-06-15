From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] 53c700: fix BUG on untagged commands
Date: Tue, 14 Jun 2016 22:00:59 -0400
Message-ID: <yq1shwfb484.fsf@sermon.lab.mkp.net>
References: <1465880407.18583.18.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <1465880407.18583.18.camel@linux.vnet.ibm.com> (James Bottomley's
	message of "Mon, 13 Jun 2016 22:00:07 -0700")
Sender: linux-parisc-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Parisc List <linux-parisc@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <jejb@linux.vnet.ibm.com> writes:

James> The untagged command case in the 53c700 driver has been broken
James> since host wide tags were enabled because the replaced
James> scsi_find_tag() function had a special case for the tag value
James> SCSI_NO_TAG to retrieve sdev-> current_cmnd.  The replacement
James> function scsi_host_find_tag() has no such special case and
James> returns NULL causing untagged commands to trigger a BUG() in the
James> driver.  Inspection shows that the 53c700 is the only driver
James> using this SCSI_NO_TAG case, so a local fix in the driver
James> suffices to fix this problem globally.

Applied to 4.7/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
