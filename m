From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v3 07/13] scsi_transport_srp: Add transport layer error
 handling
Date: Thu, 04 Jul 2013 10:16:49 +0200
Message-ID: <51D52F71.8070304@acm.org>
References: <51D41C03.4020607@acm.org> <51D41F13.6060203@acm.org>   <1372864458.24238.32.camel@frustration.ornl.gov>  <51D44A86.5050000@acm.org> <1372872474.24238.43.camel@frustration.ornl.gov>  <51D46C54.8060101@acm.org> <1372877861.24238.64.camel@frustration.ornl.gov> <51D52BD7.1090506@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51D52BD7.1090506-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 07/04/13 10:01, Bart Van Assche wrote:
> On 07/03/13 20:57, David Dillow wrote:
>> And I'm getting the strong sense that the answer to my question about
>> fast_io_fail_tmo >= 0 when dev_loss_tmo is that we should not allow that
>> combination, even if it doesn't break the kernel. If it doesn't make
>> sense, there is no reason to create an opportunity for user confusion.
>
> Let's take a step back. I think we agree that the only combinations of
> timeout parameters that are useful are those combinations that guarantee
> that SCSI commands will be finished in a reasonable time and also that
> allow multipath to detect failed paths. The first requirement comes down
> to limiting the value fast_io_fail_tmo can be set to. The second
> requirement means that either reconnect_delay or fast_io_fail_tmo must
> be set (please note that a reconnect failure changes the state of all
> involved SCSI devices into SDEV_TRANSPORT_OFFLINE). So how about
> modifying srp_tmo_valid() as follows:
> * Add an argument called "reconnect_delay".
> * Add the following code in that function:
>      if (reconnect_delay < 0 && fast_io_fail_tmo < 0 && dev_loss_tmo < 0)
>          return -EINVAL;

(replying to my own e-mail)

A small correction to what I wrote above: a reconnect failure only 
causes the SCSI device state to be changed into SDEV_TRANSPORT_OFFLINE 
if the fast_io_fail mechanism has been disabled.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
