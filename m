From: Douglas Gilbert <dougg@torque.net>
Subject: Re: SCSI Command scatter-gather number
Date: Tue, 30 Jul 2002 23:22:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D4757FF.9F91971F@torque.net>
References: <F6A3AFC9BCD92E48B79C14E4AAAEA20F45A678@nonamea.ptu.promise.com> <20020730144326.A26330@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Haofeng Kou <haofengk@ptu.promise.com>, linux-scsi@vger.kernel.org

Mike Anderson wrote:
> 
> On 2.4 the use_sg value should be limited to the smaller of MAX_SEGMENTS
> or the scsi host sg_tablesize.
> 
> This is checked in the block interface during __make_request. I believe if
> you got through the sg interface the limiting value is only sg_tablesize,
> but Doug is the best one to answer that.

Mike,
Yes, the sg driver limits the number of elements in a scatter
gather list to Scsi_Host::sg_tablesize . I haven't seen these
values over 256 but I can't see anything enforcing that (and
the type of sg_tablesize is unsigned short). [Perhaps
Scsi_Cmnd::use_sg was a unsigned char at some time in the
past.]

The 2 LLDD I use the most are advansys and sym53c8xx and
they have fixed values of 255 and 96 respectively. Small
numbers only seem to be a problem with direct IO when large
transfers (with a single command) are attempted. Since
direct IO remaps a large data block from the user space
allocated by malloc() to a scatter gather list, it must
cope with the typical case in which every page is 
discontinuous. So in the case of the sym53c8xx on i386
the biggest direct IO transfer that can be done is
96 * 4KB == 384KB .

Doug Gilbert
 
> -Mike
> 
> Haofeng Kou [haofengk@ptu.promise.com] wrote:
> > For the "struct scsi_cmnd", there is a member :
> >       unsigned short use_sg;
> > Which gives the Number of pieces of the scatter-gather.
> >
> > How to limit its value, how to set the max value for the "use_sg"?
> >
> >
> > Thanks,
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> Michael Anderson
> andmike@us.ibm.com
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
