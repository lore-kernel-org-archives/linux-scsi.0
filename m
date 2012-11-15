From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 3/3] target/iblock: Add WRITE_SAME w/ UNMAP=0 emulation
	support
Date: Thu, 15 Nov 2012 20:01:27 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40294CCF8D45@G9W0745.americas.hpqcorp.net>
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>
 <1352405238-23267-4-git-send-email-nab@linux-iscsi.org>
 <20121115110432.GD28956@infradead.org>
 <1353007786.4447.29.camel@haakon2.linux-iscsi.org>
 <20121115193235.GA5714@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121115193235.GA5714@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

WRITE SAME always has a payload, regardless of the UNMAP bit value.

For WRITE SAME with UNMAP=0, it's extremely important; that's how what to write is specified.

For WRITE SAME with UNMAP=1, the device server is required to check that the payload matches the data that is returned for unmapped LBAs.  lf LBPRZ=1 (read zeros for unmapped LBAs), that means checking that the payload has all zeros.  In sbc3r33, this rule is tucked away in model section 4.7.3.4.3, not the command section 5.41.

I would like to change that rule (it's a nuisance and a performance burden), but that's the current rule going into SBC-3 letter ballot.  

Changing WRITE SAME with UNMAP=1 to ignore the payload would provide essentially the same functionality as changing the UNMAP command to be mandatory, not just a hint; both approaches have been discussed.



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Christoph Hellwig
> Sent: Thursday, 15 November, 2012 1:33 PM
> To: Nicholas A. Bellinger
> Cc: Christoph Hellwig; target-devel; linux-scsi; linux-kernel; Christoph Hellwig;
> Martin K. Petersen
> Subject: Re: [PATCH 3/3] target/iblock: Add WRITE_SAME w/ UNMAP=0
> emulation support
> 
> On Thu, Nov 15, 2012 at 11:29:46AM -0800, Nicholas A. Bellinger wrote:
> > Well at least for the latter that is because UNMAP=0 does not have a
> > payload.  ;)
> 
> UNMAP=0 does have a payload, we just ignore it.  In fact I was told
> that targets should check for a completely zeroed sector sized payload
> for it if being pedantic.  I can't really find the justification for
> that in the standard - the closest thing to it is the stance about
> ignoring the unmap bit if the device is fully provisioned.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
