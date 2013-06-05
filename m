From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] sg: atomize check and set sdp->exclude in sg_open
Date: Wed, 5 Jun 2013 11:41:07 -0400
Message-ID: <20130605154106.GA2737@logfs.org>
References: <51AF0269.9070900@oracle.com>
 <20130605132746.GA1690@logfs.org>
 <51AF646D.7030903@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51AF646D.7030903@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vaughan <vaughan.cao@oracle.com>
Cc: dgilbert@interlog.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 6 June 2013 00:16:45 +0800, vaughan wrote:
> =E4=BA=8E 2013=E5=B9=B406=E6=9C=8805=E6=97=A5 21:27, J=C3=B6rn Engel =
=E5=86=99=E9=81=93:
> >On Wed, 5 June 2013 17:18:33 +0800, vaughan wrote:
> >>
> >>Check and set sdp->exclude should be atomic when set in sg_open().
> >
> >The patch is line-wrapped.  More importantly, it doesn't seem to do
> It's shorter than the original line, so I just leave it like this...

Sure.  What I meant by line-wrapped is that your mailer mangled the
patch.  Those two lines should have been one:
> >>-                       ((!sfds_list_empty(sdp) || get_exclude(sdp)=
)
> >>? 0 : set_exclude(sdp, 1)));

> >what your description indicates it should do.  And lastly, does this
> >fix a bug, possibly even one you have a testcase for, or was it foun=
d
> >by code inspection?
> I found it by code inspection. A race condition may happen with the
> old code if two threads are both trying to open the same sg with
> O_EXCL simultaneously. It's possible that they both find fsds list
> is empty and get_exclude(sdp) returns 0, then they both call
> set_exclude() and break out from wait_event_interruptible and resume
> open. So it's necessary to check again with sg_open_exclusive_lock
> held to ensure only one can set sdp->exclude and return >0 to break
> out from wait_event loop.

Makes sense.  And reading the code again, I have to wonder what monkey
came up with the get_exclude/set_exclude functions.

Can I sucker you into a slightly larger cleanup?  I think the entire
"get_exclude(sdp)) ? 0 : set_exclude(sdp, 1)" should be simplified.
And once you add the try_set_exclude(), set_exclude will only ever do
clear_exclude, so you might as well rename and simplify that as well.

Let no good deed go unpunished.

J=C3=B6rn

--
It's just what we asked for, but not what we want!
-- anonymous
