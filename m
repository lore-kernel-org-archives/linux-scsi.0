From: Doug Ledford <dledford@redhat.com>
Subject: Re: Question on drivers/scsi/scsi_error.c
Date: Tue, 21 May 2002 13:59:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020521135919.C2101@redhat.com>
References: <20020521143114.21069.qmail@nostromo.freenet-ag.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020521143114.21069.qmail@nostromo.freenet-ag.de>; from michael@freenet-ag.de on Tue, May 21, 2002 at 02:31:14PM -0000
List-Id: linux-scsi@vger.kernel.org
To: michael@freenet-ag.de
Cc: linux-scsi@vger.kernel.org

On Tue, May 21, 2002 at 02:31:14PM -0000, michael@freenet-ag.de wrote:
> Hello,
> 
> why does scsi_check_sense return SUCCESS on e.g. HARDWARE_ERRORs?
> 
>         case ILLEGAL_REQUEST:
>         case BLANK_CHECK:
>         case DATA_PROTECT:
>         case HARDWARE_ERROR:
>         default:
>                 return SUCCESS;
> 
> I think that those errors should return FAILED, but I may overlook
> something.  Please send Cc: to me, as I am not subscribed to the list.

Because returning SUCCESS from scsi_check_sense causes the command to be 
sent back to the upper layers as completed, where the sd layer can then 
remap the command to get around the hardware error if it so chooses and 
then send a new command back down.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
