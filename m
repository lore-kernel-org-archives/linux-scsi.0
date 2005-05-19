From: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: Connection to SAN times out after a few days
Date: Thu, 19 May 2005 15:59:50 -0400
Message-ID: <a728f9f9050519125916d4e61f@mail.gmail.com>
References: <a728f9f90505191226655f26a1@mail.gmail.com>
	 <20050519193940.GA12400@us.ibm.com>
Reply-To: Alex Deucher <alexdeucher@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.194]:9940 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261238AbVEST7z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2005 15:59:55 -0400
Received: by rproxy.gmail.com with SMTP id a41so329914rng
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2005 12:59:51 -0700 (PDT)
In-Reply-To: <20050519193940.GA12400@us.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On 5/19/05, Patrick Mansfield <patmans@us.ibm.com> wrote:
> On Thu, May 19, 2005 at 03:26:11PM -0400, Alex Deucher wrote:
> > I have Nexsan ATAbeast SAN connected to an AMD64 (sun v20z) and
> > SPARC64 (sun 220R) server using lpfc HBAs (using the in kernel lpfc
> > driver, kernel 2.6.12-rc4).  About once every 4-5 days, the server
> > loses its connection to the SAN and I get these messages in my log:
> > May 19 09:01:08 nutcracker scsi1 (0:0): rejecting I/O to offline device
> > May 19 09:01:08 nutcracker metapage_read_end_io: I/O error
> > May 19 09:01:08 nutcracker scsi1 (0:0): rejecting I/O to offline device
> > May 19 09:01:08 nutcracker metapage_read_end_io: I/O error
> > May 19 09:01:08 nutcracker ERROR: (device dm-4): DT_GETPAGE: dtree page corrupt
> > May 19 09:01:09 nutcracker scsi1 (0:0): rejecting I/O to offline device
> > May 19 09:01:09 nutcracker metapage_read_end_io: I/O error
> > May 19 09:01:09 nutcracker ERROR: (device dm-4): DT_GETPAGE: dtree page corrupt
> >
> > Nothing unusual shows up in the SAN logs.  I've already adjusted the
> > cache flushing on the SAN and changed the scsi timeouts to 45 seconds.
> >  I asked emulex about it, but I'm wondering if this is something in
> > the scsi layer.  Has anyone else had similar problems or know what the
> > problem may be?
> 
> Yes, could be a timeout, but the device would not go offline unless we
> could not talk to it at all after the timeout (TUR failed, or of course
> some bug).
> 
> There should be earlier errors about the device being offline, look for
> and post those.
> 

Sorry, I missed these earlier:

May 18 19:25:26 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x304 not found
May 18 19:26:52 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag xa6 not found
May 18 19:27:54 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a0fa
May 18 19:28:56 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a0fb
May 18 19:29:58 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a0fc
May 18 19:31:00 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a0fd
May 18 19:32:02 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a0fe
May 18 19:33:04 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a0ff
May 18 19:34:06 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a100
May 18 19:35:08 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a101
May 18 19:36:10 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a102
May 18 19:37:12 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a103
May 18 19:38:14 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a104
May 18 19:39:16 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a105
May 18 19:40:18 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a106
May 18 19:41:20 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a107
May 18 19:42:22 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a108
May 18 19:43:24 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a109
May 18 19:44:26 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a10a
May 18 19:45:28 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a10b
May 18 19:46:30 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a10c
May 18 19:47:32 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a10d
May 18 19:48:34 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a10e
May 18 19:49:36 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a10f
May 18 19:50:38 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a110
May 18 19:51:40 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a111
May 18 19:52:42 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a112
May 18 19:53:44 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a113
May 18 19:54:46 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a114
May 18 19:55:48 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a115
May 18 19:56:50 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a116
May 18 19:57:52 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a117
May 18 19:58:54 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a118
May 18 19:59:56 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a119
May 18 20:00:58 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a11a
May 18 20:02:00 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a11b
May 18 20:03:02 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a11c
May 18 20:04:04 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a11d
May 18 20:05:06 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a11e
May 18 20:06:08 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a11f
May 18 20:07:10 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a120
May 18 20:08:12 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a121
May 18 20:09:14 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a122
May 18 20:10:16 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a123
May 18 20:11:18 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a124
May 18 20:12:20 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a125
May 18 20:13:22 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a126
May 18 20:14:24 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a127
May 18 20:15:26 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a128
May 18 20:16:28 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a129
May 18 20:17:30 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a12a
May 18 20:18:32 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a12b
May 18 20:19:34 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a12c
May 18 20:20:36 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a12d
May 18 20:21:38 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a12e
May 18 20:22:40 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a12f
May 18 20:23:42 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a130
May 18 20:24:44 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a131
May 18 20:25:46 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a132
May 18 20:26:48 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a133
May 18 20:27:50 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a134
May 18 20:28:52 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a135
May 18 20:29:54 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a136
May 18 20:30:56 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a137
May 18 20:31:58 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a138
May 18 20:33:00 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a139
May 18 20:34:02 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a13a
May 18 20:35:04 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a13b
May 18 20:36:06 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a13c
May 18 20:37:08 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a13d
May 18 20:38:10 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a13e
May 18 20:39:12 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a13f
May 18 20:40:14 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a140
May 18 20:41:16 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a141
May 18 20:42:18 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a142
May 18 20:43:20 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a143
May 18 20:44:22 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a144
May 18 20:45:24 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a145
May 18 20:46:26 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a146
May 18 20:47:28 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a147
May 18 20:48:30 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a148
May 18 20:49:32 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a149
May 18 20:50:34 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a14a
May 18 20:51:36 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a14b
May 18 20:52:38 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a14c
May 18 20:53:40 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a14d
May 18 20:54:42 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a14e
May 18 20:55:44 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a14f
May 18 20:56:46 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a150
May 18 20:57:48 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a151
May 18 20:58:50 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a152
May 18 20:59:51 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a153
May 18 21:00:53 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a154
May 18 21:01:55 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a155
May 18 21:02:57 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a156
May 18 21:03:59 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a157
May 18 21:05:01 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a158
May 18 21:06:03 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a159
May 18 21:07:05 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a15a
May 18 21:08:07 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a15b
May 18 21:09:09 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a15c
May 18 21:10:11 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a15d
May 18 21:11:13 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a15e
May 18 21:12:15 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a15f
May 18 21:13:17 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a160
May 18 21:14:19 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a161
May 18 21:15:21 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a162
May 18 21:16:23 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a163
May 18 21:17:25 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a164
May 18 21:18:27 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a165
May 18 21:19:29 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a166
May 18 21:20:31 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x3 xf0a167
May 18 21:21:33 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a168
May 18 21:22:35 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a169
May 18 21:23:37 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a16a
May 18 21:24:39 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a16b
May 18 21:25:41 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x2 xf0a16c
May 18 21:26:43 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a16d
May 18 21:27:45 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a16e
May 18 21:28:47 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x0 xf0a16f
May 18 21:29:49 nutcracker lpfc 0000:03:01.0: 0:0748 abort handler
timed out waiting for abort to complete. Data: x0 x0 x1 xf0a170
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x11e not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x11f not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x120 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x121 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x122 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x123 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x124 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x125 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x126 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x127 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x128 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x129 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x12a not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x12b not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x12c not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x12d not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x12e not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x12f not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x130 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x131 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x132 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x133 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x134 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x135 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x136 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x137 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x138 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x139 not found
May 18 21:30:50 nutcracker lpfc 0000:03:01.0: 0:0327 Rsp ring 0 error
-  command completion for iotag x13a not found
May 18 21:31:52 nutcracker lpfc 0000:03:01.0: 0:0713 SCSI layer issued
LUN reset (0, 0) Data: x2002 x3 x2

Thanks,

Alex
