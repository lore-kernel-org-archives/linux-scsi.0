From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: 4.15.14 crash with iscsi target and dvd
Date: Sun, 1 Apr 2018 07:37:21 -0400
Message-ID: <20180401113721.GA8471@animx.eu.org>
References: <20180331015903.GA29398@animx.eu.org>
 <CAFLxGvzbA9XzXLsH56iyqYkitrSnBbOzD977u4266=w5zw0jNg@mail.gmail.com>
 <20180331221252.GA25573@animx.eu.org>
 <b68bf187c9cde1c36489fc5ab2187ca8750a1292.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b68bf187c9cde1c36489fc5ab2187ca8750a1292.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche wrote:
> On Sat, 2018-03-31 at 18:12 -0400, Wakko Warner wrote:
> > Richard Weinberger wrote:
> > > On Sat, Mar 31, 2018 at 3:59 AM, Wakko Warner <wakko@animx.eu.org> wrote:
> > > > I reported this before but noone responded.
> > > 
> > > Because you're sending only to LKML.
> > > CC'ing storage folks.
> > 
> > Thank you.  I wasn't sure who I needed to send it to.
> 
> Can you share the output of lsscsi? I would like to know whether or not you
> are using a (S)ATA CDROM.

>From the target:
[4:0:0:0]    cd/dvd  ATAPI    iHAS224   B      GL05  /dev/sr0 
[5:0:0:0]    cd/dvd  ATAPI    iHAS422   8      4L11  /dev/sr1 
[6:0:0:0]    cd/dvd  PBDS     DVD+-RW DH-16W1S 2D14  /dev/sr2 

>From the initiator:
[19:0:0:0]   cd/dvd  ATAPI    iHAS224   B      GL05  /dev/sr1
[19:0:0:1]   cd/dvd  ATAPI    iHAS422   8      4L11  /dev/sr2
[19:0:0:2]   cd/dvd  PBDS     DVD+-RW DH-16W1S 2D14  /dev/sr3


I tested 4.14.32 last night with the same oops.  4.9.91 works fine.
>From the initiator, if I do cat /dev/sr1 > /dev/null it works.  If I mount
/dev/sr1 and then do find -type f | xargs cat > /dev/null the target
crashes.  I'm using the builtin iscsi target with pscsi.  I can burn from
the initiator with out problems.  I'll test other kernels between 4.9 and
4.14.
