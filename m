From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 0/5 RESEND] allow HW iSCSI cards to hook into iscsi
	class
Date: Sun, 20 Nov 2005 15:27:55 -0600
Message-ID: <1132522075.7983.17.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:4738 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932084AbVKTV2C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Nov 2005 16:28:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.orglinux-scsi@vger.kernel.org

I did not realize my last patch was so large. It looks like it was to
large for linux-scsi, so here is the code broken up into a patchset
which is what I should have done first. These patches were made
against 2.6.15-rc2, but should apply against scsi-misc. For a open-iscsi
svn users a patch is here:
 http://www.cs.wisc.edu/~michaelc/iscsi/open-iscsi/transport-class/v2/

Now on to the problem:

The current iscsi class is not usable by HW iscsi drivers. This patch
refactors the class code into a interface and lib so that we both
can use the same class.

SW iscsi currently allocates a scsi_host per session (roughly a scsi_host
per I_T Nexus, or in other words I guess you could think of it as a
 scsi_host per target port (not really but I guess close enough for this
discussion)). Some nice benefits to this were:

- Finer Error handler. A host reset can map to a target reset (or iscsi
session level recovery) and there is no waiting for every target to
quiesce during timeouts.

- Scanning is very simple and fast becuase a session is not serialized through
the host and we do not need a workqueue. When we add a session, we just kick
out to userspace and scan from there (the FC rport code could probbaly go
to usersacpe too it looks like).

- There are probably others but I am too tired.

So for this transport class reshaping, I continued the scsi_host per
session allocation for HW iscsi cards too. This may be similar to
libata's scsi_host per port. When a HW iSCSI LLD is in it's driver->probe
function they can call iscsi_alloc/add_iscsi_host(). This creates
and adds a iscsi_host (similar to libatas's host_set) which is used
similar to how the scsi_host is in a SPI driver. Then when a iSCSI LLD
creates a session it can call iscsi_create_session()
(iscsi_create_session() can also be called from a userspace event
if like for open-iscsi discovery is done in userspace). iscsi_create_session,
will then allocate a scsi_host and setup a session.

We could also move the libata hostset concept to scsi-ml too and let
the transport classes do whatever for the scsi_host usage? Just a thought.

I added the setup and teardown code and a basic queucommand lib
function. The next step would be to further libata'ify iscsi and
add the iscsi error handler code. For the eh code though (and some of the
queucommand lib fn), I think I would like to somehow break out some of the
SAS task management code and scsi_error.c code so that we can share
it.



