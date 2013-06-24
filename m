From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: Re: [PATCH RESEND v2 2/2] scsi: 64-bit port of buslogic driver
Date: Mon, 24 Jun 2013 15:16:16 -0600
Message-ID: <51C8B720.3000800@oracle.com>
References: <cover.1368754558.git.khalid.aziz@oracle.com> <97daf2d29ceb78bdef3ddf6358dc634de35d0345.1368754556.git.khalid.aziz@oracle.com> <20130624210747.GA19721@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130624210747.GA19721@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Jones <davej@redhat.com>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Khalid Aziz <khalid@gonehiking.org>
List-Id: linux-scsi@vger.kernel.org

On 06/24/2013 03:07 PM, Dave Jones wrote:
> On Mon, Jun 24, 2013 at 02:26:00PM -0600, Khalid Aziz wrote:
>
>   > @@ -821,7 +821,7 @@ struct blogic_ccb {
>   >  	unsigned char cdblen;				/* Byte 2 */
>   >  	unsigned char sense_datalen;			/* Byte 3 */
>   >  	u32 datalen;					/* Bytes 4-7 */
>   > -	u32 data;					/* Bytes 8-11 */
>   > +	void *data;					/* Bytes 8-11 */
>
> The comment (and subsequent ones for this struct)  are now wrong on 64-bit.
> More of a concern though is that above this struct is this...
>
> /*
>    Define the 32 Bit Mode Command Control Block (CCB) structure.  The first 40
>    bytes are defined by and common to both the MultiMaster Firmware and the
>    FlashPoint SCCB Manager.
>
>
> Is it safe to change this if the firmware/3rd party sw is expecting it to be a u32 ?
>
> 	Dave
>

Dave,

You are right. The comment does need to be updated. It is safe though to 
change it to void *. I have verified this field is used by the lower 
layer SCCB manager (not fw) and the upper layer buslogic driver only. 
This field does get used to store 64-bit memory pointers as well as 
32-bit DMA pointers depending upon the operation specified in 
blogic_ccb, and I have made sure the usage is consistent between the two 
layers.

I can correct the comments in another patch if that is ok by James.

--
Khalid
