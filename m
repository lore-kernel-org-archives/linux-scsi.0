From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: ide-scsi command status bug
Date: Wed, 17 Jul 2002 09:33:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <000601c22d96$8a49ec80$e0019d89@cybernetics.com>
References: <3D34C299.982829BF@splentec.com>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D34C299.982829BF@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: 'Luben Tuikov' <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

> Luben Tuikov wrote:
>
> You are relying on specific Linux SCSI core behaviour
> rather than the spec. SPC-2, 7.20.1, specifies that if REQUEST
> SENSE completed successfully, i.e. the sense data is valid, then
> status GOOD is returned. If the status is CHECK CONDITION
> for a completed REQUEST SENSE command then the sense data may NOT
> be valid.

Yes, but there are two SCSI commands involved here.  There is the command
that I sent to the sg driver, which got CHECK CONDITION status, and then
there is the auto-generated Request Sense command, which got GOOD status.
Most lowlevel drivers return the CHECK CONDITION from the original command
as the status (sr_result & 0xff), which is probably the behavior most people
would expect.  The ide-scsi driver returns the GOOD status from the Request
Sense instead.

A brief look over the code indicates that this behavior is the result of the
ide-scsi driver relying on the midlevel to generate the Request Sense rather
than automatically retrieving the sense data itself.  The ide-scsi driver
returns GOOD status for the Request Sense (which is certainly the correct
thing to do), and the midlevel overwrites the original CHECK CONDITION with
the GOOD status from the Request Sense.  Looks more to be a design flaw in
the midlevel, but it only shows up with ide-scsi since other lowlevel
drivers retrieve the sense data themselves and don't rely on the midlevel
for auto-sense.

Obviously, there needs to be a way for an upper-level driver or userspace
app to tell that the original command completed with an error.  I was using
sg_io_hdr_t { status } with other lowlevel drivers, but with the ide-scsi
driver I had to check sg_io_hdr_t { driver_status } & DRIVER_SENSE instead.

> Simply: if you issue REQUEST SENSE and the command completes and
> returns valid sense data, then you should get GOOD status.

Yes, of course.  This is what I expect if I send an explicit Request Sense
to the sg driver (unsolicited sense).

I would also expect that if the internal Request Sense that is automatically
generated in response to a CHECK CONDITION itself gets a CHECK CONDITION,
then some other error code would be returned in sg_io_hdr_t {
driver_status } or sg_io_hdr_t { host_status } to indicate that the sense
data could not be retrieved.

Anthony J. Battersby
Cybernetics

