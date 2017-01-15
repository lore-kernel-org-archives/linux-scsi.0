From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: iscsi_trx going into D state
Date: Sun, 15 Jan 2017 13:15:40 -0500 (EST)
Message-ID: <685519679.16516861.1484504140472.JavaMail.zimbra@redhat.com>
References: <CAANLjFoj9-qscJOSf2jtKYt2+4cQxMHNJ9q2QTey4wyG5OTSAA@mail.gmail.com> <CAANLjForEkO6RXw7KJYrTJD=f0S8FE73vvwNQcL_ARFdFoDQqg@mail.gmail.com> <1030906614.13148012.1483722413675.JavaMail.zimbra@redhat.com> <CAANLjFocE2fbO_oWRiEVCt0=mfmgrLy9qWqqg=TH_jZS3PXn0g@mail.gmail.com> <CAANLjFpRCwGSh=HV12dc_OtFKgcjQqERSPirqxWD1w0N-G_mCg@mail.gmail.com> <CAANLjFotqoC8TKGypD2uqoADRq5NxDmXgz-B7THKy_HH_7u9hg@mail.gmail.com> <1449740553.15880491.1484320214006.JavaMail.zimbra@redhat.com> <CAANLjFrFxasp6e=jWq4FwPFjRLgX-nwHc5n+eYRTz9EjTCAQ5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFrFxasp6e=jWq4FwPFjRLgX-nwHc5n+eYRTz9EjTCAQ5g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Zhu Lingshan <lszhu-IBi9RG/b67k@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Robert LeBlanc" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "Zhu Lingshan"
> <lszhu-IBi9RG/b67k@public.gmane.org>, "linux-rdma" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Sagi Grimberg"
> <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>
> Sent: Friday, January 13, 2017 6:38:33 PM
> Subject: Re: iscsi_trx going into D state
> 
> Laurance,
> 
> I'm really starting to think that the stars aligned with the phase of
> the moon or something when I reproduced this in my lab before because
> I've been unable to reproduce it on Infiniband the last two days. The
> problem with this issue is that it is so hard to trigger, but causes a
> lot of problems when it does happen. I really hate wasting people's
> time when I can't reproduce it myself reliably. Please don't waste too
> much time if you can't get it reproduced on Infiniband, I'll have to
> wait until someone with the ConnectX-4-LX cards can replicate it.
> 
> Hmmm.... you do have ConnectX-4 cards which may have the same bug it
> Ethernet mode. I don't see the RoCE bug on my ConnectX-3 cards, but
> your ConnectX-4 cards may work. Try putting the cards into Ethernet
> mode, set the speed and advertised speed to something lower than the
> max speed and verify that the link speed is that (ethtool). On the
> ConnectX-4-LX cards, I just had to set both interfaces down and then
> back up at the same time, on the ConnectX-3 I had to pull the cable
> (shutting down the client might have worked). Then set up target and
> client with iSER, format and run the test and it should trigger
> automatically.
> 
> Looking at release notes on the ConnectX-4-LX cards, the latest
> firmware may fix the bug that so easily exposes the problem with that
> card. My cards are SuperMicro branded cards and don't have the new
> firmware available yet.
> 
> Good luck.
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> 
> 
> On Fri, Jan 13, 2017 at 8:10 AM, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> >
> >
> > ----- Original Message -----
> >> From: "Robert LeBlanc" <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
> >> To: "Laurence Oberman" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> Cc: "Doug Ledford" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger"
> >> <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "Zhu Lingshan"
> >> <lszhu-IBi9RG/b67k@public.gmane.org>, "linux-rdma" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
> >> linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Sagi Grimberg"
> >> <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Christoph Hellwig" <hch-jcswGhMUV9g@public.gmane.org>
> >> Sent: Thursday, January 12, 2017 4:26:05 PM
> >> Subject: Re: iscsi_trx going into D state
> >>
> >> Sorry sent prematurely...
> >>
> >> On Thu, Jan 12, 2017 at 2:22 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
> >> wrote:
> >> > I'm having trouble replicating the D state issue on Infiniband (I was
> >> > able to trigger it reliably a couple weeks back, I don't know if OFED
> >> > to verify the same results happen there as well.
> >>
> >> I'm having trouble replicating the D state issue on Infiniband (I was
> >> able to trigger it reliably a couple weeks back, I don't know if OFED
> >> being installed is altering things but it only installed for 3.10. The
> >> ConnectX-4-LX exposes the issue easily if you have those cards.) to
> >> verify the same results happen there as well.
> >>
> >> ----------------
> >> Robert LeBlanc
> >> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >
> > I am only back in the office next Wednesday.
> > I have this all setup using ConnectX-4 with IB/ISER but have no way of
> > remotely creating the disconnect as I currently have it back-to-back.
> > Have run multiple tests with IB and ISER hard resting the client to break
> > the IB connection but have not been able to reproduce as yet.
> > So it will have to wait until I can pull cables next week as that seemed to
> > be the way you have been reproducing this.
> >
> > This is in a code area I also don't have a lot of knowledge of the flow but
> > have started trying to understand it better.
> >
> > Thanks
> > Laurence
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Hello Robert

I will try this sometime tomorrow by running in ethernet mode.
Its been days of resets with no reproduction so I agree, very hard ro trproduce with Infiniband.

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
