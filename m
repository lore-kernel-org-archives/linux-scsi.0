From: Patrick Mansfield <patman@aracnet.com>
Subject: Re: [PATCH] /dev/disk/by-id incomplete and unhelpful for SATA drives
Date: Fri, 6 Jan 2006 10:58:12 -0800
Message-ID: <20060106185812.GA6404@aracnet.com>
References: <20051221185518.GA9100@vrfy.org> <43A9CFE0.2070103@edesix.com> <20051222043527.GA13175@vrfy.org> <43AA8D0B.10504@edesix.com> <20051222183525.GA17871@devserv.devel.redhat.com> <43AB40E2.1050009@edesix.com> <20060106013640.GA27841@aracnet.com> <43BDDCAE.7000506@torque.net> <43BE6506.7090901@torque.net> <43BE7203.8060404@edesix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <43BE7203.8060404@edesix.com>
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: Chris Paulson-Ellis <chris@edesix.com>
Cc: dougg@torque.net, Bill Nottingham <notting@redhat.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 06, 2006 at 01:34:59PM +0000, Chris Paulson-Ellis wrote:

> Note that it is still a bit different to the page 0x80 output, but I 
> don't think this matters (unless that '0' or '1' is a bug not a 
> feature). For my purposes, it just needs to be unique.
> 
> # ( scsi_id -p 0x80 -g -x -s /block/sda ; \
>     scsi_id -p 0x83 -g -x -s /block/sda ) | grep ID_SERIAL
> ID_SERIAL=SATA_Maxtor_6Y160M0_Y4DCTR3E
> ID_SERIAL=1ATA_Maxtor_6Y160M0_Y4DCTR3E

Yes, the above is a feature. The SATA in the above is actually S + ATA,
the 'S' is added to guarantee no overlap with page 83 names.

For page 80 the output is concatenation of 'S', vendor, model, and page 80
result, 

For page 83 the output puts the id type as a prefix, so the name spaces
for page 83 can't collide - they are mostly unique across a given id type,
but not for vendor specific, hence we also add model + vendor for vendor
specific.

And for '-x', extra spaces are removed and then spaces converted to '_'.

-- Patrick Mansfield


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
