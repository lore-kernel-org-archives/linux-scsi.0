From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 8 of 8] libata: Report disk alignment and physical block size
Date: Thu, 23 Apr 2009 10:05:50 -0400
Message-ID: <yq1iqkvbh35.fsf@sermon.lab.mkp.net>
References: <patchbomb.1240464567@sermon.lab.mkp.net>
	<29bae7aef942a1709bb6.1240464575@sermon.lab.mkp.net>
	<20090423134617.GO1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090423134617.GO1926@parisc-linux.org> (Matthew Wilcox's
	message of "Thu, 23 Apr 2009 07:46:17 -0600")
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Matthew" == Matthew Wilcox <matthew@wil.cx> writes:

Matthew> I found it clearer to do:
Matthew> 			u16 first = word_209 & 0x3fff; if
Matthew> 			(first)
Matthew> 				lowest_aligned = (1 <<
Matthew> 				log_per_phys) - first;

Matthew> but you may disagree.

I don't care much either way.


>> + rbuf[14] = (lowest_aligned_lba >> 8) & 0x3f;

Matthew> Hm, yes, it could overflow ... 1 << 0xf -1 is 32767 (0x7fff)
Matthew> which would be larger than could fit in SCSI's RC16 and ends up
Matthew> inadvertently setting Thin Provisioning Read Zeroes, which we
Matthew> really don't want.  I suppose reporting 0x3fff is better than
Matthew> reporting anything else in this field.  All highly theoretical,
Matthew> since you'd have to have 16MB physical sectors with 512 byte
Matthew> logical sectors to get to this situation.

Yeah, I agree it's mostly in the academic interest bucket.  Just trying
to be defensive about what we return, that's all.

-- 
Martin K. Petersen	Oracle Linux Engineering
