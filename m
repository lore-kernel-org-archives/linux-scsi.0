From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] sd.c fixes applied incorectly to 2.4.19-preXX
Date: Mon, 15 Apr 2002 15:13:37 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204152113.g3FLDb982996@aslan.scsiguy.com>
References: <200204152051.g3FKpOa25340@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Your message of "Mon, 15 Apr 2002 15:51:24 CDT."
             <200204152051.g3FKpOa25340@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi@vger.kernel.org, Alan Cox <alan@redhat.com>

>gibbs@scsiguy.com said:
>> Looking at the latest version of your tree via bitkeeper, it seems
>> that the wrong patch has been applied to sd.c.  In its current state,
>> the disk driver will fail to act upon any sense data returned by the
>> low level controller.  The following patch restores correct behavior. 
>
>Actually, this should be using the scsi_sense_valid() function call in 
>scsi_error.c, shouldn't it?  Especially since the criterion for valid sense is
> 
>merely that bit 7 be set with the error code (which can be either 0x70 or 
>0x71) in bits 0-6.

Well, if we really wanted to fix it correctly:

1) All of the HBA drivers would set DRIVER_SENSE when sense data
   is available.  Right now many do set it, but because some drivers
   do not, the mid-layer doesn't trust it.

2) The mid-layer would look at DRIVER_SENSE before ever looking
   in the sense buffer.  Currently, and HBA driver has to zero out
   the first byte of the sense buffer to ensure the peripheral drivers
   don't believe that sense is available when it really isn't (stale data
   from previous sense retrieval).

3) The peripheral drivers would understand how to deal with deferred errors.

The check against 0xF0 is currently "correct" because the code in sd.c's
rw_intr doesn't know how to deal with anything other than a current
error (0x70 + valid bit).

--
Justin
