From: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH RESEND v2 2/2] scsi: 64-bit port of buslogic driver
Date: Mon, 24 Jun 2013 17:07:47 -0400
Message-ID: <20130624210747.GA19721@redhat.com>
References: <cover.1368754558.git.khalid.aziz@oracle.com>
 <97daf2d29ceb78bdef3ddf6358dc634de35d0345.1368754556.git.khalid.aziz@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <97daf2d29ceb78bdef3ddf6358dc634de35d0345.1368754556.git.khalid.aziz@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 24, 2013 at 02:26:00PM -0600, Khalid Aziz wrote:

 > @@ -821,7 +821,7 @@ struct blogic_ccb {
 >  	unsigned char cdblen;				/* Byte 2 */
 >  	unsigned char sense_datalen;			/* Byte 3 */
 >  	u32 datalen;					/* Bytes 4-7 */
 > -	u32 data;					/* Bytes 8-11 */
 > +	void *data;					/* Bytes 8-11 */

The comment (and subsequent ones for this struct)  are now wrong on 64-bit.
More of a concern though is that above this struct is this...

/*
  Define the 32 Bit Mode Command Control Block (CCB) structure.  The first 40
  bytes are defined by and common to both the MultiMaster Firmware and the
  FlashPoint SCCB Manager.


Is it safe to change this if the firmware/3rd party sw is expecting it to be a u32 ?

	Dave
