From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] 2.6.2-rc2 - MPT Fusion driver 3.00.02 update
Date: Tue, 27 Jan 2004 18:11:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040128021114.GA433675@sgi.com>
References: <0E3FA95632D6D047BA649F95DAB60E5703D19D33@exa-atlanta.se.lsil.com> <1075136727.2290.48.camel@mulgrave> <20040126193413.A3302@infradead.org> <20040127061800.GB429536@sgi.com> <401627C3.20101@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.SGI.COM ([192.48.171.6]:21893 "EHLO rj.sgi.com")
	by vger.kernel.org with ESMTP id S265809AbUA1CMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2004 21:12:19 -0500
Content-Disposition: inline
In-Reply-To: <401627C3.20101@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, "Moore, Eric Dean" <Emoore@lsil.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 27, 2004 at 06:56:35PM +1000, Douglas Gilbert wrote:
> Jeremy Higdon wrote:
> >On Mon, Jan 26, 2004 at 07:34:13PM +0000, Christoph Hellwig wrote:
> >
> >>On Mon, Jan 26, 2004 at 11:05:26AM -0600, James Bottomley wrote:
> >>
> >>>>I had avoided it due the comments in the code
> >>>>from sralston and pdelaney about sg interface 
> >>>>gererating wrong direction in some cases.  
> >>>
> >>>If you find a problem, I'll fix the generic code...
> >>
> >>I think it's just very old comments.  We had such a problem in early 2.4
> >>kernels, but it has been fixed for ages.  If it wasn't most of the scsi
> >>drivers would have a big problem.
> >
> >
> >Aren't there three interfaces for sg, or did the early ones go away
> >in 2.6?  I recall that we ran into trouble with sg setting the
> >direction incorrectly in 2.4 kernels when using older interface,
> >I think.
> 
> Jeremy,
> I can't see any such report in my changelogs for the sg
> driver during the lk 2.4 series. What was difficult with
> the older sg interface (sg_header based) was setting the
> command length as this was "guessed" from the first 3 bits
> of the opcode (SCSI_IOCTL_SEND_COMMAND ioctl still does this).
> 
> Doug Gilbert

Okay.  Here is where we ran into problems.

In sg_write(), if old_hdr.reply_len is greater than SZ_SG_HEADER,
then hp->dxfer_direction is set to SG_DXFER_TO_FROM_DEV.  Then
in sg_common_write(), if hp->dxfer_direction is SG_DXFER_TO_FROM_DEV,
then SRpnt->sr_data_direction is set to SCSI_DATA_READ.

For whatever reason, there seem to be apps out there that issue
SCSI data_out commands using the old interface and yet set the
reply_len in the old header to something larger than SZ_SG_HEADER.

Since we couldn't fix the app (it wasn't ours and we didn't have
source), we added code to our xscsi-scsi i/f.  It's a variation of
code that is in both the LSI and Qlogic drivers (borrowed from LSI,
as you can see from the comment).  Without it, some sg apps just
wouldn't work properly (the app in question that we had trouble
with was a Mylex RAID management tool).

So if you remove this code from the Fusion driver, some of these
things will stop working.  One answer would be to change the
apps, but that isn't really practical.  Another would be to put
this logic into sg, so that it's at least centralized.

jeremy

static int
xscsi_scsi_io_direction(Scsi_Cmnd *cmd)
{
        /*
         * Code borrowed from drivers/message/fusion/mptscsih.c::mptscsih_io_direction()
         * 09/23/2003 by Michael Reed, SGI:
         *    Copied, renamed, removed ifdef (and code) and tweaked.
         */

        switch (cmd->cmnd[0]) { /* hot path */
        case READ_6:
        case READ_10:
                return SCSI_DATA_READ;
                break;
        case WRITE_6:
        case WRITE_10:
                return SCSI_DATA_WRITE;
                break;
        }

        switch (cmd->cmnd[0]) {
        /*  _DATA_OUT commands  */
        case WRITE_LONG:        case WRITE_SAME:        case WRITE_BUFFER:
        case WRITE_12:          case WRITE_VERIFY:      case WRITE_VERIFY_12:
        case COMPARE:           case COPY:              case COPY_VERIFY:                                      
        case SEARCH_EQUAL:      case SEARCH_HIGH:       case SEARCH_LOW:                                       
        case SEARCH_EQUAL_12:   case SEARCH_HIGH_12:    case SEARCH_LOW_12:                                    
        case MODE_SELECT:       case MODE_SELECT_10:    case LOG_SELECT:                                       
        case SEND_DIAGNOSTIC:   case CHANGE_DEFINITION: case UPDATE_BLOCK:                                     
        case SET_WINDOW:        case MEDIUM_SCAN:       case SEND_VOLUME_TAG:                                  
        case REASSIGN_BLOCKS:   case PERSISTENT_RESERVE_OUT:                                                   
        case 0xea:              case 0xa3:                                                                     
                return SCSI_DATA_WRITE;                                                                        
                                                                                                               
        /*  No data transfer commands  */                                                                      
        case SEEK_6:            case SEEK_10:                                                                  
        case RESERVE:           case RELEASE:                                                                  
        case TEST_UNIT_READY:   case START_STOP:                                                               
        case ALLOW_MEDIUM_REMOVAL:                                                                             
                return SCSI_DATA_NONE;                                                                         
                                                                                                               
        /*  Conditional data transfer commands  */                                                             
        case FORMAT_UNIT:                                                                                      
                if (cmd->cmnd[1] & 0x10)        /* FmtData (data out phase)? */                                
                        return SCSI_DATA_WRITE;                                                                
                else                                                                                           
                        return SCSI_DATA_NONE;                                                                 
                                                                                                               
        case VERIFY:                                                                                           
                if (cmd->cmnd[1] & 0x02)        /* VERIFY:BYTCHK (data out phase)? */                          
                        return SCSI_DATA_WRITE;                                                                
                else                                                                                           
                        return SCSI_DATA_NONE;                                                                 
                                                                                                               
        case RESERVE_10:                                                                                       
                if (cmd->cmnd[1] & 0x03)        /* RESERVE:{LongID|Extent} (data out phase)? */                
                        return SCSI_DATA_WRITE;                                                                
                else                                                                                           
                        return SCSI_DATA_NONE;                                                                 
                                                                                                               
        /*  Covered write cases, presume read. */                                                              
        default:                                                                                               
                return SCSI_DATA_READ;                                                                         
        }                                                                                                      

